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
        
        let user = try userSnapshot.data(as: User.self)
        
        return user
    }
}
