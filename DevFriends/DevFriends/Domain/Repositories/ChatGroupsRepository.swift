//
//  ChatGroupsRepository.swift
//  DevFriends
//
//  Created by 유승원 on 2022/11/18.
//

protocol ChatGroupsRepository {
    func fetch(uids: [String]) async throws -> [Group]
}
