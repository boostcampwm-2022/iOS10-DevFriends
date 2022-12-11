//
//  DefaultChatGroupsRepository.swift
//  DevFriends
//
//  Created by 유승원 on 2022/11/22.
//

import Network
import Foundation
import FirebaseFirestore

final class DefaultChatGroupsRepository: ContainsFirestore {
    let groupStorage: ChatGroupsStorage
    let messageStorage: ChatMessagesStorage
    
    private var groupIDs: [String] = []
    
    init(
        groupStorage: ChatGroupsStorage,
        messageStorage: ChatMessagesStorage
    ) {
        self.groupStorage = groupStorage
        self.messageStorage = messageStorage
    }
}

extension DefaultChatGroupsRepository: ChatGroupsRepository {
    func fetchFromLocal() -> [AcceptedGroup] {
        // 1. realm에서 그룹을 가져온다.
        let localAcceptedGroups = groupStorage.fetch()
        
        return localAcceptedGroups
    }
    
    func fetch(userID: String, completion: @escaping (_ group: AcceptedGroup) -> Void) {
        let localAcceptedGroups = groupStorage.fetch()
        
        // 1. firestore에서 [UserGroupResponseDTO]를 가져오면서 리스너를 할당받는다.
        fetchUserGroupInfo(of: userID) { userGroupResponseDTO in
            let userGroup = userGroupResponseDTO.toDomain()
            Task {
                let group = try await self.fetchGroup(uid: userGroup.groupID)
                
                var lastMessageTime: Date?
                if let index = localAcceptedGroups
                    .firstIndex(where: { return $0.group.id == group.id }) {
                    lastMessageTime = localAcceptedGroups[index].time
                }
                
                self.fetchLastMessages(
                    group: group,
                    userGroup: userGroup,
                    lastMessageTime: lastMessageTime
                ) { group, userGroup, messages in
                    var acceptedGroup: AcceptedGroup
                    let localAcceptedGroups = self.groupStorage.fetch()
                    // (message is empty && 원래 렘에 저장되어 있던 그룹)이면 업데이트할 필요 없음
                    if messages.isEmpty && localAcceptedGroups.contains(where: { acceptedGroup in
                        return acceptedGroup.group.id == group.id
                    }) {
                        return
                    } else {
                        acceptedGroup = AcceptedGroup(
                            group: group,
                            time: messages.last?.time ?? userGroup.time,
                            lastMessageContent: messages.last?.content ?? "",
                            newMessageCount: messages.count
                        )
                    }
                    completion(acceptedGroup) // SW: 여기서 반복적으로 Diffable이 업데이트됨
                    do {
                        try self.groupStorage.save(acceptedGroup: acceptedGroup) // SW: realm에도 저장함
                    } catch {
                        print(error)
                    }
                }
            }
        }
    }
    
    /// User의 uid document에 있는 그룹 중에서 lastAcceptedTime 이후에 있는 그룹을 가져온다.
    func fetchUserGroupInfo(of uid: String, lastAcceptedTime: Date?) async throws -> [UserGroupResponseDTO] {
        var query: Query = firestore
            .collection(FirestorePath.user.rawValue)
            .document(uid)
            .collection(FirestorePath.group.rawValue)
        
        if let lastAcceptedTime = lastAcceptedTime {
            query = query.whereField("time", isGreaterThan: lastAcceptedTime)
        }
        
        let groups = try await query.getDocuments().documents
            .map { try $0.data(as: UserGroupResponseDTO.self) }
        return groups
    }
    
    /// User Group을 모두 가져온다
    func fetchUserGroupInfo(of uid: String, completion: @escaping (_ group: UserGroupResponseDTO) -> Void) {
        let query: Query = firestore
            .collection(FirestorePath.user.rawValue)
            .document(uid)
            .collection(FirestorePath.group.rawValue)
            .order(by: "time", descending: true)
        
        query.addSnapshotListener { snapshot, _ in
            snapshot?.documents
                .compactMap { document in
                    return try? document.data(as: UserGroupResponseDTO.self)
                }
                .filter { !self.groupIDs.contains($0.groupID) }
                .forEach {
                    self.groupIDs.append($0.groupID)
                    completion($0)
                }
        }
    }
    
    private func fetchGroup(uid: String) async throws -> Group {
        let groupSnapshot = try await firestore
            .collection(FirestorePath.group.rawValue)
            .document(uid)
            .getDocument()
        let group = try groupSnapshot.data(as: GroupResponseDTO.self)
        
        return group.toDomain()
    }
    
    private func fetchLastMessages(group: Group, userGroup: UserGroup, lastMessageTime: Date?, completion: @escaping (_ group: Group, _ userGroup: UserGroup, _ messages: [Message]) -> Void) {
        var query: Query = firestore
            .collection(FirestorePath.chat.rawValue)
            .document(group.chatID)
            .collection(FirestorePath.message.rawValue)
        
        if let lastMessageTime = lastMessageTime {
            query = query.whereField("time", isGreaterThan: lastMessageTime)
        }
        
        query = query.order(by: "time", descending: false)
        
        query.addSnapshotListener { snapshot, _ in
            if let snapshot {
                do {
                    let messages = try snapshot.documentChanges
                        .map {
                            try $0.document.data(as: MessageResponseDTO.self)
                                .toDomain()
                        }
                        .filter { $0.time.firestamp() != lastMessageTime?.firestamp() }
                    completion(group, userGroup, messages)
                } catch {
                    print(error)
                }
            }
        }
    }
    
    private func fetchLastMessage(chatID: String) async throws -> Message? {
        var query: Query = firestore
            .collection(FirestorePath.chat.rawValue)
            .document(chatID)
            .collection(FirestorePath.message.rawValue)
            .order(by: "time", descending: false)
            .limit(to: 1)
        
        let newMessage = try await query
            .getDocuments()
            .documents
            .first
            .map {
                try $0.data(as: MessageResponseDTO.self)
                    .toDomain()
            }
        
        return newMessage
    }
}
