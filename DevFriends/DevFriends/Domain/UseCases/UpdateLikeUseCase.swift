//
//  UpdateLikeUseCase.swift
//  DevFriends
//
//  Created by 상현 on 2022/11/29.
//

import Foundation

protocol UpdateLikeUseCase {
    func execute(like: Bool, user: User, groupID: String)
}

final class DefaultUpdateLikeUseCase: UpdateLikeUseCase {
    private let userRepository: UserRepository
    private let groupRepository: GroupRepository
    
    init(userRepository: UserRepository, groupRepository: GroupRepository) {
        self.userRepository = userRepository
        self.groupRepository = groupRepository
    }
    
    func execute(like: Bool, user: User, groupID: String) {
        var tempUser = user
        
        if like == true {
            tempUser.likeGroupIDs.append(groupID)
        } else {
            tempUser.likeGroupIDs.removeAll { $0 == groupID }
        }
        
        self.userRepository.update(tempUser)
        self.groupRepository.updateLike(groupID: groupID, increment: like)
    }
}
