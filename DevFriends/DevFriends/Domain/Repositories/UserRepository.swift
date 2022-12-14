//
//  UserRepository.swift
//  DevFriends
//
//  Created by 유승원 on 2022/11/18.
//

import FirebaseFirestore

protocol UserRepository {
    func fetch(uid: String) async throws -> User
    func update(userID: String, user: User)
    func update(_ user: User)
    func isExist(uid: String) async throws -> Bool
    func create(uid: String?, user: User, completion: @escaping (Error?) -> Void) throws
    func fetch(uid: String, completion: @escaping (_ user: User) -> Void) -> ListenerRegistration
    func createUserGroup(userID: String, groupID: String)
    func fetchUserGroup(of uid: String) async throws -> [UserGroup]
    func deleteUserGroup(userID: String, groupID: String)
    func updateUserGroup(userID: String, groupID: String, userGroup: UserGroup) async throws
    func delete(id: String)
}
