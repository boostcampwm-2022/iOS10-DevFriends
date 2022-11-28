//
//  DefaultUserRepository.swift
//  DevFriends
//
//  Created by 유승원 on 2022/11/22.
//

import Foundation
import FirebaseFirestore

final class DefaultUserRepository: ContainsFirestore {}

extension DefaultUserRepository: UserRepository {
    func fetch(uid: String) async throws -> User {
        let userSnapshot = try await firestore.collection("User").document(uid).getDocument()
        let user = try userSnapshot.data(as: UserResponseDTO.self)
        return user.toDomain()
    }
    
    func update(userID: String, user: User) {
        do {
            let userResponseDTO = makeUserResponseDTO(user: user)
            try firestore.collection("User").document(userID).setData(from: userResponseDTO)
        } catch {
            print(error)
        }
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
                .setData(from: makeUserResponseDTO(user: user))
        } catch {
            print(error)
        }
    }
    
    func addUserToGroup(userID: String, groupID: String) {
        let userGroupResponseDTO = UserGroupResponseDTO(groupID: groupID, time: .now)
        do {
            _ = try firestore
                .collection("User")
                .document(userID)
                .collection("Group")
                .addDocument(from: userGroupResponseDTO)
        } catch {
            print(error)
        }
    }
}

// MARK: Private
extension DefaultUserRepository {
    private func makeUserResponseDTO(user: User) -> UserResponseDTO {
        return UserResponseDTO(
            nickname: user.nickname,
            job: user.job,
            profileImagePath: user.profileImagePath,
            categories: user.categoryIDs,
            appliedGroups: user.appliedGroupIDs
        )
    }
}
