//
//  FetchUserUseCase.swift
//  DevFriends
//
//  Created by 상현 on 2022/11/21.
//

import Foundation

protocol LoadUserUseCase {
    func execute(userId: String) async throws -> User
}

final class DefaultLoadUserUseCase: LoadUserUseCase {
    private let userRepository: UserRepository
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    func execute(userId: String) async throws -> User {
        return try await self.userRepository.fetch(uid: userId)
    }
}
