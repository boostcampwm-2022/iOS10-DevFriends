//
//  LeaveGroupUseCase.swift
//  DevFriends
//
//  Created by 상현 on 2022/12/07.
//

import Foundation

protocol LeaveGroupUseCase {
    func execute(userID: String, group: Group)
}

final class DefaultLeaveGroupUseCase: LeaveGroupUseCase {
    private let userRepository: UserRepository
    private let groupRepository: GroupRepository
    
    init(userRepository: UserRepository, groupRepository: GroupRepository) {
        self.userRepository = userRepository
        self.groupRepository = groupRepository
    }
    
    func execute(userID: String, group: Group) {
        var tempGroup = group
        tempGroup.participantIDs.removeAll { $0 == userID }
        
        groupRepository.update(groupID: group.id, group: tempGroup)
        userRepository.deleteUserGroup(userID: userID, groupID: group.id)
    }
}
