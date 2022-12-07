//
//  UpdateUserInfoUseCase.swift
//  DevFriends
//
//  Created by 상현 on 2022/11/29.
//

import Foundation

protocol UpdateUserInfoUseCase {
    func execute(profileImagePath: String, nickName: String, job: String, user: User, categoryIDs: [String])
}

final class DefaultUpdateUserInfoUseCase: UpdateUserInfoUseCase {
    private let userRepository: UserRepository
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    func execute(profileImagePath: String, nickName: String, job: String, user: User, categoryIDs: [String]) {
        var tempUser = user
        tempUser.profileImagePath = profileImagePath
        tempUser.nickname = nickName
        tempUser.job = job
        tempUser.categoryIDs = categoryIDs
        
        return self.userRepository.update(tempUser)
    }
}
