//
//  DefaultUserRepository.swift
//  DevFriends
//
//  Created by 유승원 on 2022/11/22.
//

import Foundation
import FirebaseFirestore

final class DefaultUserRepository {}

extension DefaultUserRepository: UserRepository {
    func fetch(uid: String) async throws -> User {
        let userSnapshot = try await firestore.collection("User").document(uid).getDocument()
        
        let user = try userSnapshot.data(as: UserResponseDTO.self)
        
        return user.toDomain()
    }
    
    func fetch(uids: [String]) async throws -> [User] {
        return try await withThrowingTaskGroup(of: User.self) { taskGroup in
            uids.forEach { id in
                if id.isEmpty { return }
                
                taskGroup.addTask {
                    try await self.fetch(uid: id)
                }
            }
            
            return try await taskGroup.reduce(into: []) { partialResult, user in
                partialResult.append(user)
            }
        }
    }
    
    func update(_ user: User) {
        do {
            try firestore
                .collection("User")
                .document(user.id)
                .setData(from: makeUserResponseDTO(user))
        } catch {
            print(error)
        }
    }
    
    private func makeUserResponseDTO(_ user: User) -> UserResponseDTO {
        return UserResponseDTO(
            nickname: user.nickname,
            job: user.job,
            profileImagePath: user.profileImagePath,
            categories: user.categories,
            groups: user.groups,
            appliedGroups: user.appliedGroups
        )
    }
}
