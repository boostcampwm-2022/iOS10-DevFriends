//
//  FetchGroupUseCase.swift
//  DevFriends
//
//  Created by 심주미 on 2022/11/19.
//

import Foundation

protocol FetchGroupUseCase {
    func execute(groupType: GroupType?, location: Location?, distance: Double?) async throws -> [Group]
}

final class DefaultFetchGroupUseCase: FetchGroupUseCase {
    let groupRepository: GroupRepository
    
    init(groupRepository: GroupRepository) {
        self.groupRepository = groupRepository
    }
    
    func execute(groupType: GroupType?, location: Location?, distance: Double?) async throws -> [Group] {
        return try await groupRepository.fetch(groupType: groupType, location: location, distance: distance)
    }
}
