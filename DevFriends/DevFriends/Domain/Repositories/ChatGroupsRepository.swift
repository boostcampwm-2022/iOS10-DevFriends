//
//  ChatGroupsRepository.swift
//  DevFriends
//
//  Created by 유승원 on 2022/11/18.
//

import Foundation

protocol ChatGroupsRepository: ContainsFirestore {
    func fetch(uids: [String]) async throws -> [Group]
}
