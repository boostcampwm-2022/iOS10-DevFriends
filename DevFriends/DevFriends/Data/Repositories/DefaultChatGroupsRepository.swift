//
//  DefaultChatGroupsRepository.swift
//  DevFriends
//
//  Created by 유승원 on 2022/11/22.
//

import FirebaseFirestore

final class DefaultChatGroupsRepository: ContainsFirestore {}

extension DefaultChatGroupsRepository: ChatGroupsRepository {
    func fetch(uids: [String]) async throws -> [Group] {
        return try await withThrowingTaskGroup(of: Group.self) { taskGroup in
            for uid in uids {
                taskGroup.addTask {
                    try await self.fetchGroup(uid: uid)
                }
            }
            
            return try await taskGroup.reduce(into: []) { $0.append($1) }
        }
    }
}

// MARK: Private
extension DefaultChatGroupsRepository {
    private func fetchGroup(uid: String) async throws -> Group {
        let groupSnapshot = try await firestore.collection(FirestorePath.group.rawValue).document(uid).getDocument()
        let group = try groupSnapshot.data(as: GroupResponseDTO.self)
        
        return group.toDomain()
    }
}
