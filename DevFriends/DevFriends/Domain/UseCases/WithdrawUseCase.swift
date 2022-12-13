//
//  WithdrawUseCase.swift
//  DevFriends
//
//  Created by 상현 on 2022/12/11.
//

import Foundation

protocol WithdrawUseCase {
    func execute(userID: String, joinedGroupIDs: [String])
}

final class DefaultWithdrawUseCase: WithdrawUseCase {
    private let userRepository: UserRepository
    private let groupRepository: GroupRepository
    
    init(userRepository: UserRepository, groupRepository: GroupRepository) {
        self.userRepository = userRepository
        self.groupRepository = groupRepository
    }
    
    func execute(userID: String, joinedGroupIDs: [String]) {
        Task {
            for groupID in joinedGroupIDs {
                await groupRepository.deleteUser(userID, from: groupID)
            }
            userRepository.delete(id: userID)
        }
    }
}
