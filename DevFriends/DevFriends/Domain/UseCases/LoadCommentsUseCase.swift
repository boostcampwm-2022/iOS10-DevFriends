//
//  LoadCommentsUseCase.swift
//  DevFriends
//
//  Created by 상현 on 2022/11/21.
//

import Foundation

protocol LoadCommentsUseCase {
    func execute(groupId: String, from: Date?, limit: Int) async throws -> [Comment]
}

final class DefaultLoadCommentsUseCase: LoadCommentsUseCase {
    private let commentRepository: GroupCommentRepository
    
    init(commentRepository: GroupCommentRepository) {
        self.commentRepository = commentRepository
    }
    
    func execute(groupId: String, from: Date?, limit: Int) async throws -> [Comment] {
        return try await self.commentRepository.fetch(groupId, from: from, limit: limit)
    }
}
