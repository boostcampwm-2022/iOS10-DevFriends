//
//  LoadUserGroupIDsUseCase.swift
//  DevFriends
//
//  Created by 상현 on 2022/12/06.
//

import Foundation

protocol LoadUserGroupIDsUseCase {
    func execute(userId: String) async throws -> [String]
}

final class DefaultLoadUserGroupIDsUseCase: LoadUserGroupIDsUseCase {
    private let userRepository: UserRepository
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    func execute(userId: String) async throws -> [String] {
        return try await self.userRepository.fetchUserGroup(of: userId).map { $0.groupID }
    }
}
