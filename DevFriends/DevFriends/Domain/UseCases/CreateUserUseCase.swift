//
//  CreateUserUseCase.swift
//  DevFriends
//
//  Created by 유승원 on 2022/11/30.
//

import Foundation

protocol CreateUserUseCase {
    func execute(uid: String?, nickname: String, job: String, email: String)
}

final class DefaultCreateUserUseCase: CreateUserUseCase {
    private let userRepository: UserRepository
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    func execute(uid: String?, nickname: String, job: String, email: String) {
        let user = User(
            id: "",
            nickname: nickname,
            job: job,
            email: email,
            profileImagePath: "",
            categoryIDs: [String](),
            appliedGroupIDs: [String]()
        )
        
        do {
            try userRepository.create(uid: uid, user: user)
        } catch {
            print(error)
        }
    }
}
