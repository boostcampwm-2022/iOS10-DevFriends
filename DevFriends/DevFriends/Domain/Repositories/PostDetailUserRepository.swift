//
//  UserRepository.swift
//  DevFriends
//
//  Created by 상현 on 2022/11/21.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

protocol UserRepository: ContainsFirestore {
    func fetch(_ userId: String) async throws -> User
    func fetch(_ userIds: [String]) async throws -> [User]
}

final class DefaultUserRepository: UserRepository {
    func fetch(_ userId: String) async throws -> User {
        let snapshot = try await firestore.collection("User").document(userId).getDocument()
        
        return try snapshot.data(as: User.self)
    }
    
    func fetch(_ userIds: [String]) async throws -> [User] {
        return try await withThrowingTaskGroup(of: User.self) { taskGroup in
            userIds.forEach { id in
                if id.isEmpty { return }
                
                taskGroup.addTask {
                    try await self.fetch(id)
                }
            }
            
            return try await taskGroup.reduce(into: []) { partialResult, user in
                partialResult.append(user)
            }
        }
    }
}
