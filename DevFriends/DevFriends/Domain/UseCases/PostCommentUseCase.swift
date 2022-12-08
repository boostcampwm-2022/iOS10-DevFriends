//
//  PostCommentUseCase.swift
//  DevFriends
//
//  Created by 상현 on 2022/11/23.
//

import Foundation

protocol PostCommentUseCase {
    func execute(comment: Comment, groupId: String) -> String
}

final class DefaultPostCommentUseCase: PostCommentUseCase {
    private let commentRepository: GroupCommentRepository
    private let groupReposiotry: GroupRepository
    
    init(commentRepository: GroupCommentRepository, groupRepository: GroupRepository) {
        self.commentRepository = commentRepository
        self.groupReposiotry = groupRepository
    }
    
    func execute(comment: Comment, groupId: String) -> String {
        groupReposiotry.updateCommentNumber(groupID: groupId)
        return self.commentRepository.create(comment, to: groupId)
    }
}
