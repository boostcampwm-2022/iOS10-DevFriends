//
//  FetchUserUseCase.swift
//  DevFriends
//
//  Created by 상현 on 2022/11/21.
//

import Foundation

protocol FetchUserUseCase {
    func execute(userId: String) async throws -> User
    func execute(userIds: [String]) async throws -> [User]
}

final class DefaultFetchUserUseCase: FetchUserUseCase {
    private let userRepository: UserRepository
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    func execute(userId: String) async throws -> User {
        return try await self.userRepository.fetch(uid: userId)
    }
    
    func execute(userIds: [String]) async throws -> [User] {
        return try await self.userRepository.fetch(uids: userIds)
    }
}
