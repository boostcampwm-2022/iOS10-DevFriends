//
//  GroupRepository.swift
//  DevFriends
//
//  Created by 심주미 on 2022/11/19.
//

import Foundation

protocol GroupRepository {
    func fetch(groupType: GroupType?, location: (latitude: Double, longitude: Double)?) async throws -> [Group]
    
    func save(group: Group)
}
