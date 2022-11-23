//
//  GroupCommentRepository.swift
//  DevFriends
//
//  Created by 상현 on 2022/11/21.
//

import Foundation

protocol GroupCommentRepository: ContainsFirestore {
    func fetch(_ groupId: String) async throws -> [Comment]
}