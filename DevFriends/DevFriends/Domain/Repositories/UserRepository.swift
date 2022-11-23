//
//  UserRepository.swift
//  DevFriends
//
//  Created by 유승원 on 2022/11/18.
//

import Foundation

protocol UserRepository: ContainsFirestore {
    func fetch(uid: String) async throws -> User
    func fetch(uids: [String]) async throws -> [User]
    func update(_ user: User)
}
