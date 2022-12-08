//
//  UpdateHitUseCase.swift
//  DevFriends
//
//  Created by 상현 on 2022/12/08.
//

import Foundation

protocol UpdateHitUseCase {
    func execute(groupID: String)
}

final class DefaultUpdateHitUseCase: UpdateHitUseCase {
    private let groupRepository: GroupRepository
    
    init(groupRepository: GroupRepository) {
        self.groupRepository = groupRepository
    }
    
    func execute(groupID: String) {
        self.groupRepository.updateHit(groupID: groupID)
    }
}
