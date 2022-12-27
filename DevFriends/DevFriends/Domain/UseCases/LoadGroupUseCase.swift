//
//  LoadGroupUseCase.swift
//  DevFriends
//
//  Created by 심주미 on 2022/11/19.
//

import Foundation

protocol LoadGroupUseCase {
    func execute(groupType: GroupType?, location: Location?, distance: Double?) async throws -> [Group]
    func execute(filter: Filter) async throws -> [Group]
    func execute(ids: [String]) async throws -> [Group]
    func execute(id: String) async throws -> Group?
}

final class DefaultLoadGroupUseCase: LoadGroupUseCase {
    private let groupRepository: GroupRepository
    private let myInfoRepository: MyInfoRepository
    
    init(groupRepository: GroupRepository, myInfoRepository: MyInfoRepository) {
        self.groupRepository = groupRepository
        self.myInfoRepository = myInfoRepository
    }
    
    func execute(id: String) async throws -> Group? {
        return try await groupRepository.fetch(groupID: id)
    }
    
    func execute(groupType: GroupType?, location: Location?, distance: Double?) async throws -> [Group] {
        return try await groupRepository.fetch(groupType: groupType, location: location, distance: distance)
    }
    
    func execute(filter: Filter) async throws -> [Group] {
        return try await groupRepository.fetch(filter: filter, myUserID: myInfoRepository.uid)
    }
    
    func execute(ids: [String]) async throws -> [Group] {
        return try await groupRepository.fetch(groupIDs: ids)
    }
}
