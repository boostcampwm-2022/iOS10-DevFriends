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
    func fetch(userID: String) async throws -> [AcceptedGroup] {
        // 1. realm에서 그룹을 가져온다.
        var localAcceptedGroups = groupStorage.fetch()
        
        // 2. firestore에서 새로운 메세지를 가져오고 그룹을 업데이트한다.
        for i in 0..<localAcceptedGroups.count {
            let acceptedGroup = localAcceptedGroups[i]
            do {
                // 해당 그룹의 로컬에 저장된 메세지를 들고 온다
                let localMessages = messageStorage.fetch(groupID: acceptedGroup.group.id)
                
                // 로컬에 저장되지 않은 새로운 메세지를 들고 온다
                let newMessages = try await fetchLastMessages(
                    chatID: acceptedGroup.group.chatID,
                    lastMessageTime: localMessages.last?.time
                )
                
                // 들고 온 메세지의 마지막 시간을 AcceptedGroup에 업데이트해준다
                let newAcceptedGroup = AcceptedGroup(
                    group: acceptedGroup.group,
                    time: acceptedGroup.time,
                    lastMessageContent: newMessages.last?.content ?? localMessages.last?.content ?? "",
                    newMessageCount: newMessages.count
                )
                
                // 업데이트된 AcceptedGroup으로 바꿔준다
                localAcceptedGroups[i] = newAcceptedGroup
            } catch {
                print(error)
            }
        }
        
        // 3. 위에서 기존 로컬에 들어있던 그룹에 대한 업데이트를 싹 했고
        // 이제 새롭게 모임에 승인되어서 firestore에 새로운 Group이 생겼을 때 이를 가져온다
        let newAcceptedGroupInfos = try await fetchUserGroupInfo(
            of: userID,
            lastAcceptedTime: localAcceptedGroups.first?.time // SW: 왜 localAcceptedGroups 첫번째 시간을 썼는지 주석 or 직관적으로 보일 수 있게 수정하면 좋을 것 같습니다
        )
        var newAcceptedGroups: [AcceptedGroup] = []
        for groupInfo in newAcceptedGroupInfos {
            do {
                let group = try await fetchGroup(uid: groupInfo.groupID)
                
                let newMessages = try await fetchLastMessages(
                    chatID: group.chatID,
                    lastMessageTime: nil
                )
                let newAcceptedGroup = AcceptedGroup(
                    group: group,
                    time: groupInfo.time,
                    lastMessageContent: newMessages.last?.content ?? "",
                    newMessageCount: newMessages.count
                )
                newAcceptedGroups.append(newAcceptedGroup)
            } catch {
                print(error)
            }
        }
        try groupStorage.save(acceptedGroups: newAcceptedGroups)
        return (localAcceptedGroups + newAcceptedGroups)
    }
    
    /// User의 uid document에 있는 그룹 중에서 lastAcceptedTime 이후에 있는 그룹을 가져온다.
    func fetchUserGroupInfo(of uid: String, lastAcceptedTime: Date?) async throws -> [UserGroupResponseDTO] {
        var query: Query = firestore
            .collection("User")
            .document(uid)
            .collection("Group")
            
        if let lastAcceptedTime = lastAcceptedTime {
            query = query.whereField("time", isGreaterThan: lastAcceptedTime)
        }
        
        let groups = try await query.getDocuments().documents
            .map { try $0.data(as: UserGroupResponseDTO.self) }
        return groups
    }
    
    private func fetchGroup(uid: String) async throws -> Group {
        let groupSnapshot = try await firestore
            .collection("Group")
            .document(uid)
            .getDocument()
        let group = try groupSnapshot.data(as: GroupResponseDTO.self)
        
        return group.toDomain()
    }
    
    // SW: 마지막 메세지s만 가져온다는 것이 어떤 의미인지? 마지막 메세지 하나만 필요한거면 Message만 반환해도 좋을 것 같다
    // SW: .limit을 이용하시면 좋을 것 같다
    private func fetchLastMessages(chatID: String, lastMessageTime: Date?) async throws -> [Message] {
        var query: Query = firestore
            .collection("Chat")
            .document(chatID)
            .collection("Message")
        
        if let lastMessageTime = lastMessageTime {
            query = query.whereField("time", isGreaterThan: lastMessageTime)
        }
        
        query = query.order(by: "time", descending: false)
        
        let newMessages = try await query
            .getDocuments()
            .documents
            .map {
                try $0.data(as: MessageResponseDTO.self)
                .toDomain()
            }
        return newMessages
    }
}
