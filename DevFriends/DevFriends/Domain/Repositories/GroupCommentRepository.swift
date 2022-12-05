//
//  GroupCommentRepository.swift
//  DevFriends
//
//  Created by 상현 on 2022/11/21.
//

protocol GroupCommentRepository {
    func create(_ comment: Comment, to groupId: String) -> String
    func fetch(_ groupId: String, limit: Int) async throws -> [Comment]
}
