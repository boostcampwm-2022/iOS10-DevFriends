//
//  GroupRepository.swift
//  DevFriends
//
//  Created by 심주미 on 2022/11/19.
//

protocol GroupRepository: ContainsFirestore {
    func create(group: Group) -> String
    func fetch(groupType: GroupType?, location: Location?, distance: Double?) async throws -> [Group]
    func fetch(groupID: String) async throws -> Group?
    func fetch(groupIDs: [String]) async throws -> [Group]
    func fetch(filter: Filter, myUserID: String?) async throws -> [Group]
    func update(groupID: String, group: Group)
    func updateHit(groupID: String)
    func updateLike(groupID: String, increment: Bool)
    func updateCommentNumber(groupID: String)
    func delete(id: String) async
    func deleteUser(_ userID: String, from groupID: String) async
}
