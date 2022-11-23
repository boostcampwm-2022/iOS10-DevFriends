//
//  SendNotificationToParticipantUseCase.swift
//  DevFriends
//
//  Created by 유승원 on 2022/11/22.
//

import Foundation

protocol SendNotificationToParticipantUseCase {
    func execute(groupID: String, senderID: String, groupTitle: String, type: NotificationJoinType)
}

final class DefaultSendNotificationToParticipantUseCase: SendNotificationToParticipantUseCase {
    private let notificationRepository: NotificationRepository
    
    init(notificationRepository: NotificationRepository) {
        self.notificationRepository = notificationRepository
    }
    
    func execute(groupID: String, senderID: String, groupTitle: String, type: NotificationJoinType) {
        switch type {
        case .accepted:
            let notification = Notification(groupID: groupID, groupTitle: groupTitle, type: "joinSuccess")
            notificationRepository.send(uid: senderID, notification: notification)
        case .denied:
            break
            // TODO: 미래의 누군가가 할 것이야..
        }
    }
}
