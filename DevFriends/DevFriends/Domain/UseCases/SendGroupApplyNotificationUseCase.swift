//
//  SendGroupApplyNotificationUseCase.swift
//  DevFriends
//
//  Created by 상현 on 2022/11/27.
//

import Foundation

protocol SendGroupApplyNotificationUseCase {
    func execute(from user: User, to group: Group)
}

final class DefaultSendGroupApplyNotificationUseCase: SendGroupApplyNotificationUseCase {
    private let notificationRepository: NotificationRepository
    
    init(notificationRepository: NotificationRepository) {
        self.notificationRepository = notificationRepository
    }
    
    func execute(from user: User, to group: Group) {
        notificationRepository.send(
            to: group.managerID,
            notification: Notification(
                groupID: group.id,
                groupTitle: group.title,
                senderID: user.id,
                senderNickname: user.nickname,
                type: .joinRequest,
                isAccepted: false
            )
        )
    }
}
