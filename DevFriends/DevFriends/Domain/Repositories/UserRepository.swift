//
//  UserRepository.swift
//  DevFriends
//
//  Created by 유승원 on 2022/11/18.
//

import Foundation

protocol UserRepository: ContainsFirestore {
    func fetchUser() async throws -> User
}

final class DefaultUserRepository {}

extension DefaultUserRepository: UserRepository {
    func fetchUser() async throws -> User {
        guard let uid = UserDefaults.standard.object(forKey: "uid") as? String
        else { fatalError("UID was not stored!!") }
        let userSnapshot = try await firestore.collection("User").document(uid).getDocument()
        guard let user = userSnapshot.data(),
            let nickname = user["nickname"] as? String,
            let profileImagePath = user["profileImagePath"] as? String,
            let categories = user["categories"] as? [String],
            let groups = user["groups"] as? [String]
        else { fatalError("User Infomation Is Strange!!") }
        
        return User(
            nickname: nickname,
            profileImagePath: profileImagePath,
            categories: categories,
            groups: groups
        )
    }
}
