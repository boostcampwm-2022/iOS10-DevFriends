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
    func fetchUser() async throws -> User {
        // MARK: user를 나중에 어떻게 가져올지 논의해보기
        guard let uid = UserDefaults.standard.object(forKey: "uid") as? String
        else { fatalError("UID was not stored!!") }
        let userSnapshot = try await firestore.collection("User").document(uid).getDocument()
        
        let user = try userSnapshot.data(as: User.self)
        
        return user
    }
}
