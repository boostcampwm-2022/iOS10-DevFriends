//
//  CreateUserUseCase.swift
//  DevFriends
//
//  Created by 유승원 on 2022/11/30.
//

import Foundation

protocol CreateUserUseCase {
    func execute(uid: String?, nickname: String, job: String, email: String, completion: @escaping (Error?) -> Void)
}

final class DefaultCreateUserUseCase: CreateUserUseCase {
    private let userRepository: UserRepository
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    func execute(uid: String?, nickname: String, job: String, email: String, completion: @escaping (Error?) -> Void) {
        let user = User(
            id: "",
            nickname: nickname,
            job: job,
            email: email,
            profileImagePath: "",
            categoryIDs: [String](),
            appliedGroupIDs: [String](),
            likeGroupIDs: [String]()
        )
        
        do {
            try userRepository.create(uid: uid, user: user) { error in
                completion(error)
            }
        } catch {
            print(error)
        }
    }
}
