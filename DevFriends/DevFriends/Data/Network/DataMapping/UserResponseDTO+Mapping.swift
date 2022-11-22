//
//  UserResponseDTO+Mapping.swift
//  DevFriends
//
//  Created by 심주미 on 2022/11/22.
//
import Foundation
import FirebaseFirestoreSwift

struct UserResponseDTO: Codable {
    @DocumentID var uid: String?
    let nickname: String
    let job: String
    let profileImagePath: String
    let categories: [String]
    let groups: [String]
}

extension UserResponseDTO {
    func toDomain() -> User {
        return User(
            id: uid ?? "",
            nickname: nickname,
            job: job,
            profileImagePath: profileImagePath,
            categories: categories,
            groups: groups
        )
    }
}
