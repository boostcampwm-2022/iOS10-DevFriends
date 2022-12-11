//
//  UpdateUserGroupsToAddGroupUseCase.swift
//  DevFriends
//
//  Created by 유승원 on 2022/11/22.
//

import Foundation

protocol UpdateUserGroupsToAddGroupUseCase {
    func execute(groupID: String, userID: String) async throws
}

final class DefaultUpdateUserGroupsToAddGroupUseCase: UpdateUserGroupsToAddGroupUseCase {
    private let userRepository: UserRepository
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    func execute(groupID: String, userID: String) async throws {
        let user = try await self.userRepository.fetch(uid: userID)
        let updatedUser = self.removeGroupIDInAppliedGroups(user: user, groupID: groupID)
        self.userRepository.update(userID: userID, user: updatedUser)
        self.userRepository.createUserGroup(userID: userID, groupID: groupID)
    }
}

extension DefaultUpdateUserGroupsToAddGroupUseCase {
    private func removeGroupIDInAppliedGroups(user: User, groupID: String) -> User {
        var user = user
        if let index = user.appliedGroupIDs.firstIndex(of: groupID) {
            user.appliedGroupIDs.remove(at: index)
        }
        return user
    }
}
