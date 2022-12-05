//
//  CheckUserUseCase.swift
//  DevFriends
//
//  Created by 유승원 on 2022/11/29.
//

import Foundation

protocol CheckUserUseCase {
    func execute(uid: String) async throws -> Bool
}

final class DefaultCheckUserUseCase: CheckUserUseCase {
    private let userRepository: UserRepository
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    func execute(uid: String) async throws -> Bool {
        let isExist = try await userRepository.isExist(uid: uid)
        
        return isExist
    }
}
