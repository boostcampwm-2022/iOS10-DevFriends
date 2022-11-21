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
}

final class DefaultUserRepository: UserRepository {
    func fetch(_ userId: String) async throws -> User {
        let snapshot = try await firestore.collection("User").document(userId).getDocument()
        
        return try snapshot.data(as: User.self)
    }
}
