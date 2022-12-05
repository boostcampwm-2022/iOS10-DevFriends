//
//  SendCommentNotificationUseCase.swift
//  DevFriends
//
//  Created by 상현 on 2022/11/27.
//

import Foundation

protocol SendCommentNotificationUseCase {
    func execute(sender: User, group: Group, comment: Comment, commentID: String)
}

final class DefaultSendCommentNotificationUseCase: SendCommentNotificationUseCase {
    private let notificationRepository: NotificationRepository
    
    init(notificationRepository: NotificationRepository) {
        self.notificationRepository = notificationRepository
    }
    
    func execute(sender: User, group: Group, comment: Comment, commentID: String) {
        notificationRepository.create(
            to: group.managerID,
            notification: Notification(
                groupID: group.id,
                groupTitle: group.title,
                senderID: sender.id,
                senderNickname: sender.nickname,
                commentID: commentID,
                comment: comment.content,
                type: .comment
            )
        )
    }
}
