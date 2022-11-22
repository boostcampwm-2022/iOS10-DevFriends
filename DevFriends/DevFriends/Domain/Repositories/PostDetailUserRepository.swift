//
//  UserRepository.swift
//  DevFriends
//
//  Created by 상현 on 2022/11/21.
//

import Foundation

protocol UserRepository: ContainsFirestore {
    func fetch(_ userId: String) async throws -> User
    func fetch(_ userIds: [String]) async throws -> [User]
}
