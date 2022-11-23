//
//  SendCommentNotificationToHost.swift
//  DevFriends
//
//  Created by 유승원 on 2022/11/23.
//

import Foundation

protocol SendCommentNotificationToHostUseCase {
    func execute(hostID: String, group: Group, sender: User, comment: Comment)
}

final class DefaultSendCommentNotificationToHostUseCase: SendCommentNotificationToHostUseCase {
    private let notificationRepository: NotificationRepository
    
    init(notificationRepository: NotificationRepository) {
        self.notificationRepository = notificationRepository
    }
    
    func execute(hostID: String, group: Group, sender: User, comment: Comment) {
        let notification = Notification(
            groupID: group.id,
            groupTitle: group.title,
            senderID: sender.id,
            senderNickname: sender.nickname,
            commentID: comment.id,
            comment: comment.content,
            type: NotificationType.comment.rawValue
        )
        notificationRepository.send(to: hostID, notification: notification)
    }
}
