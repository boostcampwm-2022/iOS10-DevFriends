//
//  UpdateLikeUseCase.swift
//  DevFriends
//
//  Created by 상현 on 2022/11/29.
//

import Foundation

protocol UpdateLikeUseCase {
    func execute(like: Bool, user: User, group: Group)
}

final class DefaultUpdateLikeUseCase: UpdateLikeUseCase {
    private let userRepository: UserRepository
    private let groupRepository: GroupRepository
    
    init(userRepository: UserRepository, groupRepository: GroupRepository) {
        self.userRepository = userRepository
        self.groupRepository = groupRepository
    }
    
    func execute(like: Bool, user: User, group: Group) {
        var tempUser = user
        var tempGroup = group
        
        if like == true {
            tempUser.likeGroupIDs.append(group.id)
            tempGroup.like += 1
        } else {
            tempUser.likeGroupIDs.removeAll { $0 == group.id }
            tempGroup.like -= 1
        }
        
        self.userRepository.update(tempUser)
        self.groupRepository.update(groupID: tempGroup.id, group: tempGroup)
    }
}
