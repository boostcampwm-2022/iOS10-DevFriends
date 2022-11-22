//
//  DefaultChatGroupsRepository.swift
//  DevFriends
//
//  Created by 유승원 on 2022/11/22.
//

import Foundation
import FirebaseFirestore

final class DefaultChatGroupsRepository {}

extension DefaultChatGroupsRepository: ChatGroupsRepository {
    func fetch(uids: [String]) async throws -> [Group] {
        return try await withThrowingTaskGroup(of: Group.self) { taskGroup in
            for uid in uids {
                taskGroup.addTask {
                    try await self.fetchGroup(uid: uid)
                }
            }
            
            return try await taskGroup.reduce(into: []) { partialResult, group in
                partialResult.append(group)
            }
        }
    }
    
    private func fetchGroup(uid: String) async throws -> Group {
        let groupSnapshot = try await firestore.collection("Group").document(uid).getDocument()
        let group = try groupSnapshot.data(as: Group.self)
        
        return group
    }
}
