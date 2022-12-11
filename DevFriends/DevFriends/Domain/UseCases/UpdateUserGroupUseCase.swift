//
//  UpdateUserGroupUseCase.swift
//  DevFriends
//
//  Created by 유승원 on 2022/12/10.
//

import Foundation

protocol UpdateUserGroupUseCase {
    func execute(groupID: String, time: Date)
}

final class DefaultUpdateUserGroupUseCase: UpdateUserGroupUseCase {
    private let userRepository: UserRepository
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    func execute(groupID: String, time: Date) {
        guard let userID = UserManager.shared.uid else { return }
        let userGroup = UserGroup(groupID: groupID, time: time)
        Task {
            do {
                try await userRepository.updateUserGroup(userID: userID, groupID: groupID, userGroup: userGroup)
            } catch {
                print(error)
            }
        }
    }
}
