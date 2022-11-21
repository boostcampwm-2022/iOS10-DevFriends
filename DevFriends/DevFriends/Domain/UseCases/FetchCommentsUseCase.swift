//
//  FetchCommentsUseCase.swift
//  DevFriends
//
//  Created by 상현 on 2022/11/21.
//

import Foundation

protocol FetchCommentsUseCase {
    func execute(groupId: String) async throws -> [Comment]
}

final class DefaultFetchCommentsUseCase: FetchCommentsUseCase {
    private let commentRepository: CommentRepository
    
    init(commentRepository: CommentRepository) {
        self.commentRepository = commentRepository
    }
    
    func execute(groupId: String) async throws -> [Comment] {
        return try await self.commentRepository.fetchComments(groupId: groupId)
    }
}
