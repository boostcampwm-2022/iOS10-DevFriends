//
//  GroupCommentRepository.swift
//  DevFriends
//
//  Created by 상현 on 2022/11/21.
//

import Foundation

protocol GroupCommentRepository: ContainsFirestore {
    func fetch(_ groupId: String, limit: Int) async throws -> [Comment]
    func post(_ comment: Comment, to groupId: String) -> String
}
