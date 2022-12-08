//
//  SaveUserGroupIDUseCase.swift
//  DevFriends
//
//  Created by 이대현 on 2022/12/07.
//

import Foundation

protocol SaveUserGroupIDUseCase {
    func execute(userId: String, groupID: String)
}

final class DefaultSaveUserGroupIDsUseCase: SaveUserGroupIDUseCase {
    private let userRepository: UserRepository
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    func execute(userId: String, groupID: String) {
        self.userRepository.createUserGroup(userID: userId, groupID: groupID)
    }
}
