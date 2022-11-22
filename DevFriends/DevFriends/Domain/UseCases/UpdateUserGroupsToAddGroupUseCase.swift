//
//  UpdateUserGroupsToAddGroupUseCase.swift
//  DevFriends
//
//  Created by 유승원 on 2022/11/22.
//

import Foundation

protocol UpdateUserGroupsToAddGroupUseCase {
    func execute(groupID: String, senderID: String) async throws
}

final class DefaultUpdateUserGroupsToAddGroupUseCase: UpdateUserGroupsToAddGroupUseCase {
    private let userRepository: UserRepository
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    func execute(groupID: String, senderID: String) async throws {
        var user = try await self.userRepository.fetch(uid: senderID)
        var tempGroups = user.groups
        tempGroups.append(groupID)
        user.groups = tempGroups
        
        self.userRepository.update(userID: senderID, user: user)
    }
}
