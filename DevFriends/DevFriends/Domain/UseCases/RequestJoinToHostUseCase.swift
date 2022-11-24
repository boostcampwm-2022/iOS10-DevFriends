//
//  RequestJoinToHostUseCase.swift
//  DevFriends
//
//  Created by 유승원 on 2022/11/23.
//

import Foundation

protocol RequestJoinToHostUseCase {
    func execute(group: Group, sender: User)
}

final class DefaultRequestJoinToHostUseCase: RequestJoinToHostUseCase {
    private let notificationRepository: NotificationRepository
    
    init(notificationRepository: NotificationRepository) {
        self.notificationRepository = notificationRepository
    }
    
    func execute(group: Group, sender: User) {
        let notification = Notification(
            groupID: group.id,
            groupTitle: group.title,
            senderID: sender.id,
            senderNickname: sender.nickname,
            type: NotificationType.joinRequest,
            isAccepted: false
        )
        notificationRepository.send(to: group.managerID, notification: notification)
    }
}
