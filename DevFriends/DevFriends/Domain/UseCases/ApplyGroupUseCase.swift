//
//  ApplyGroupUseCase.swift
//  DevFriends
//
//  Created by 상현 on 2022/11/24.
//

import Foundation

protocol ApplyGroupUseCase {
    func execute(user: User)
}

final class DefaultApplyGroupUseCase: ApplyGroupUseCase {
    private let userRepository: UserRepository
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    func execute(user: User) {
        userRepository.update(user)
    }
}
