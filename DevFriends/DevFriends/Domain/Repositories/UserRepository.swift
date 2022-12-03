//
//  UserRepository.swift
//  DevFriends
//
//  Created by 유승원 on 2022/11/18.
//

protocol UserRepository {
    func fetch(uid: String) async throws -> User
    func fetch(uids: [String]) async throws -> [User]
    func update(userID: String, user: User)
    func update(_ user: User)
    func createUserGroup(userID: String, groupID: String)
    func fetchUserGroup(of uid: String) async throws -> [UserGroup]
}
