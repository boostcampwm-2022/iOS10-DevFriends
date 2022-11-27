//
//  SendCommentNotificationUseCase.swift
//  DevFriends
//
//  Created by 상현 on 2022/11/27.
//

import Foundation

protocol SendCommentNotificationUseCase {
    func execute(group: Group, comment: Comment)
}

final class DefaultSendCommentNotificationUseCase: SendCommentNotificationUseCase {
    private let notificationRepository: NotificationRepository
    
    init(notificationRepository: NotificationRepository) {
        self.notificationRepository = notificationRepository
    }
    
    func execute(group: Group, comment: Comment) {
        notificationRepository.send(
            to: group.managerID,
            notification: Notification(
                groupID: group.id,
                groupTitle: group.title,
                senderID: comment.userID,
                comment: comment.content,
                type: .comment
            )
        )
    }
}
