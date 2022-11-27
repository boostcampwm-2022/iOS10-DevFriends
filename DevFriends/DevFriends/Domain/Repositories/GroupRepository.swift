//
//  GroupRepository.swift
//  DevFriends
//
//  Created by 심주미 on 2022/11/19.
//

import Foundation

protocol GroupRepository: ContainsFirestore {
    func fetch(groupType: GroupType?, location: Location?, distance: Double?) async throws -> [Group]
    func fetch(groupID: String) async throws -> Group
    func fetch(filter: Filter) async throws -> [Group]
    func save(group: Group)
    func update(groupID: String, group: Group)
}
