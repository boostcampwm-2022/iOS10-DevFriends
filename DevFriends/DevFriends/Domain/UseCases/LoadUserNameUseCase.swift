//
//  LoadUserNameUseCase.swift
//  DevFriends
//
//  Created by 유승원 on 2022/11/21.
//

import Foundation

protocol LoadUserNameUseCase {
    func fetch() async throws -> String
}

final class DefaultLoadUserNameUseCase: LoadUserNameUseCase {
    private let userRepository: UserRepository
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    func fetch() async throws -> String {
        let user = try await self.userRepository.fetchUser()
        return user.nickname
    }
}
