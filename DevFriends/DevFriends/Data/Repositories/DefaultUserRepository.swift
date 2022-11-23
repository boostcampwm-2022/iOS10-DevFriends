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
}

// MARK: Private
extension DefaultUserRepository {
    private func makeUserResponseDTO(user: User) -> UserResponseDTO {
        return UserResponseDTO(
            nickname: user.nickname,
            profileImagePath: user.profileImagePath,
            categories: user.categories,
            groups: user.groups
        )
    }
}
