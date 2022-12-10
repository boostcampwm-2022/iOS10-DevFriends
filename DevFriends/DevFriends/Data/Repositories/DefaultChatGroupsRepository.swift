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
    var acceptedGroupListener: ListenerRegistration?
    
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
    
    func fetch(
        userID: String,
        messageListenersProcess: @escaping (_ messageListeners: [ListenerRegistration]) -> Void,
        groupProcess: @escaping (_ group: AcceptedGroup) -> Void
    ) -> ListenerRegistration {
        let localAcceptedGroups = groupStorage.fetch() // SW: Completion을 3개 쓰는게 나을까 그냥 이렇게 따로 쓰는게 나을까?
        
        // 1. firestore에서 [UserGroupResponseDTO]를 가져오면서 리스너를 할당받는다.
        let groupListListener = fetchUserGroupInfo(of: userID) { userGroupResponseDTOs in
            Task {
                let messageListeners = try await withThrowingTaskGroup(of: ListenerRegistration.self) { taskGroup in
                    userGroupResponseDTOs.forEach { userGroupResponseDTO in
                        taskGroup.addTask {
                            let group = try await self.fetchGroup(uid: userGroupResponseDTO.groupID)
                            
                            var lastMessageTime: Date?
                            if let index = localAcceptedGroups.firstIndex(where: { return $0.group.id == group.id }) {
                                lastMessageTime = localAcceptedGroups[index].time
                            } else {
                                lastMessageTime = nil
                            }
                            
                            let messageListener = self.fetchLastMessages(
                                chatID: group.chatID,
                                lastMessageTime: lastMessageTime
                            ) { messages in
                                let acceptedGroup = AcceptedGroup(
                                    group: group,
                                    time: userGroupResponseDTO.time,
                                    lastMessageContent: messages.last?.content ?? "",
                                    newMessageCount: messages.count
                                )
                                
                                groupProcess(acceptedGroup) // SW: 여기서 반복적으로 Diffable이 업데이트됨
                                
                                do {
                                    try self.groupStorage.save(acceptedGroup: acceptedGroup) // SW: realm에도 저장함
                                } catch {
                                    print(error)
                                }
                            }
                            
                            return messageListener
                        }
                    }
                    
                    return try await taskGroup.reduce(into: []) { $0.append($1) }
                }
                
                messageListenersProcess(messageListeners)
            }
        }
        
        return groupListListener
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
    
    func fetchUserGroupInfo(of uid: String, completion: @escaping (_ groups: [UserGroupResponseDTO]) -> Void) -> ListenerRegistration {
        let query: Query = firestore
            .collection(FirestorePath.user.rawValue)
            .document(uid)
            .collection(FirestorePath.group.rawValue)
        
        return query.addSnapshotListener { snapshot, _ in
            if let groups = snapshot?.documents
                .compactMap({ document in
                    return try? document.data(as: UserGroupResponseDTO.self)
                }) {
                completion(groups)
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
    
    private func fetchLastMessages(chatID: String, lastMessageTime: Date?, completion: @escaping (_ messages: [Message]) -> Void) -> ListenerRegistration {
        var query: Query = firestore
            .collection(FirestorePath.chat.rawValue)
            .document(chatID)
            .collection(FirestorePath.message.rawValue)
        
        if let lastMessageTime = lastMessageTime {
            query = query.whereField("time", isGreaterThan: lastMessageTime)
        }
        
        query = query.order(by: "time", descending: false)
        
        return query.addSnapshotListener { snapshot, _ in
            if let snapshot {
                do {
                    let messages = try snapshot.documents
                        .map {
                            try $0.data(as: MessageResponseDTO.self)
                                .toDomain()
                        }
                        .filter { $0.time.firestamp() != lastMessageTime?.firestamp() }
                    completion(messages)
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
