//
//  SaveGroupUseCase.swift
//  DevFriends
//
//  Created by 심주미 on 2022/11/20.
//

import Foundation

protocol SaveGroupUseCase {
    func execute(group: Group) -> String
}

final class DefaultSaveGroupUseCase: SaveGroupUseCase {
    let groupRepository: GroupRepository
    
    init(groupRepository: GroupRepository) {
        self.groupRepository = groupRepository
    }
    
    func execute(group: Group) -> String {
        return groupRepository.create(group: group)
    }
}
