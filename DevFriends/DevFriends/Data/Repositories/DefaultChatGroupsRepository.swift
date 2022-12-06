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
        var localAcceptedGroups = groupStorage.fetch()
        for i in 0..<localAcceptedGroups.count {
            let acceptedGroup = localAcceptedGroups[i]
            do {
                let localMessages = messageStorage.fetch(groupID: acceptedGroup.group.id)
                let newMessages = try await fetchLastMessages(
                    groupID: acceptedGroup.group.id,
                    lastMessageTime: localMessages.last?.time
                )
                let newAcceptedGroup = AcceptedGroup(
                    group: acceptedGroup.group,
                    time: acceptedGroup.time,
                    lastMessageContent: newMessages.last?.content ?? localMessages.last?.content ?? "",
                    newMessageCount: newMessages.count
                )
                localAcceptedGroups[i] = newAcceptedGroup
            } catch {
                print(error)
            }
        }
        let newAcceptedGroupInfos = try await fetchUserGroupInfo(
            of: userID,
            lastAcceptedTime: localAcceptedGroups.first?.time
        )
        var newAcceptedGroups: [AcceptedGroup] = []
        for groupInfo in newAcceptedGroupInfos {
            do {
                let group = try await fetchGroup(uid: groupInfo.groupID)
                let localMessages = messageStorage.fetch(groupID: groupInfo.groupID)
                let newMessages = try await fetchLastMessages(
                    groupID: groupInfo.groupID,
                    lastMessageTime: localMessages.last?.time
                )
                let newAcceptedGroup = AcceptedGroup(
                    group: group,
                    time: groupInfo.time,
                    lastMessageContent: newMessages.last?.content ?? localMessages.last?.content ?? "",
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
    
    private func fetchLastMessages(groupID: String, lastMessageTime: Date?) async throws -> [Message] {
        let localMessages = messageStorage.fetch(groupID: groupID)
        var query: Query = firestore
            .collection("Chat")
            .document(groupID)
            .collection("Message")
        
        if let lastMessageTime = localMessages.last?.time {
            query = query.whereField("time", isGreaterThan: lastMessageTime)
        }
        
        query = query.order(by: "time", descending: false)
        
        let newMessages = try await query
            .getDocuments()
            .documents
            .map{
                try $0.data(as: MessageResponseDTO.self)
                .toDomain()
            }
        return newMessages
    }
}
