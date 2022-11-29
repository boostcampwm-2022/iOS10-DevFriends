//
//  UserRepository.swift
//  DevFriends
//
//  Created by 유승원 on 2022/11/18.
//

import Foundation

protocol UserRepository {
    func fetch(uid: String) async throws -> User
    func update(userID: String, user: User)
    func fetch(uids: [String]) async throws -> [User]
    func update(_ user: User)
    func isExist(uid: String) async throws -> Bool
    func fetchUserGroup(of uid: String) async throws -> [UserGroup]
    func addUserToGroup(userID: String, groupID: String)
}
