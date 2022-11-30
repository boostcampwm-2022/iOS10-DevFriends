//
//  FetchCommentsUseCase.swift
//  DevFriends
//
//  Created by 상현 on 2022/11/21.
//

import Foundation

protocol FetchCommentsUseCase {
    func execute(groupId: String, limit: Int) async throws -> [Comment]
}

final class DefaultFetchCommentsUseCase: FetchCommentsUseCase {
    private let commentRepository: GroupCommentRepository
    
    init(commentRepository: GroupCommentRepository) {
        self.commentRepository = commentRepository
    }
    
    func execute(groupId: String, limit: Int) async throws -> [Comment] {
        return try await self.commentRepository.fetch(groupId, limit: limit)
    }
}
