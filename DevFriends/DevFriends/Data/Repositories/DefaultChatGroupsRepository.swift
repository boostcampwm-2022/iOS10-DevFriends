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
    let monitor = NWPathMonitor()
    let storage: ChatGroupsStorage
    
    init(storage: ChatGroupsStorage) {
        self.storage = storage
    }
}

extension DefaultChatGroupsRepository: ChatGroupsRepository {
    func fetch(userID: String) async throws -> [Group] {
        let localAcceptedGroups = storage.fetch()
        let userGroupInfos = try await fetchUserGroupInfo(
            of: userID,
            lastAcceptedTime: localAcceptedGroups.first?.time
        )
        var newAcceptedGroups: [AcceptedGroup] = []
        for groupInfo in userGroupInfos {
            do {
                let group = try await fetchGroup(uid: groupInfo.groupID)
                newAcceptedGroups.append(AcceptedGroup(group: group, time: groupInfo.time))
            } catch {
                print(error)
            }
        }
        try storage.save(acceptedGroups: newAcceptedGroups)
        return (localAcceptedGroups + newAcceptedGroups).map{ $0.group }
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
}
