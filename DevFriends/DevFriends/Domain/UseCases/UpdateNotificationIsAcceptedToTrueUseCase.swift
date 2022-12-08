//
//  UpdateNotificationIsAcceptedToTrueUseCase.swift
//  DevFriends
//
//  Created by 유승원 on 2022/11/22.
//

import Foundation

protocol UpdateNotificationIsAcceptedToTrueUseCase {
    func execute(notification: Notification)
}

final class DefaultUpdateNotificationIsAcceptedToTrueUseCase: UpdateNotificationIsAcceptedToTrueUseCase {
    private let notificationRepository: NotificationRepository
    
    init(notificationRepository: NotificationRepository) {
        self.notificationRepository = notificationRepository
    }
    
    func execute(notification: Notification) {
        // MARK: user를 나중에 어떻게 가져올지 논의해보기
        guard let uid = UserManager.shared.uid
        else { fatalError("UID was not stored!!") }
        notificationRepository.update(isAccepted: true, userID: uid, notification: notification)
    }
}
