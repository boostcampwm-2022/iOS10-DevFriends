//
//  PostCommentUseCase.swift
//  DevFriends
//
//  Created by 상현 on 2022/11/23.
//

import Foundation

protocol PostCommentUseCase {
    func execute(comment: Comment, groupId: String)
}

final class DefaultPostCommentUseCase: PostCommentUseCase {
    private let commentRepository: GroupCommentRepository
    
    init(commentRepository: GroupCommentRepository) {
        self.commentRepository = commentRepository
    }
    
    func execute(comment: Comment, groupId: String) {
        return self.commentRepository.post(comment, to: groupId)
    }
}
