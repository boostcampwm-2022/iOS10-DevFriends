//
//  DefaultPostDetailUserRepository.swift
//  DevFriends
//
//  Created by 상현 on 2022/11/22.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

final class DefaultUserRepository: UserRepository {
    func fetch(_ userId: String) async throws -> User {
        let snapshot = try await firestore.collection("User").document(userId).getDocument()
        
        return try snapshot.data(as: UserResponseDTO.self).toDomain()
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
