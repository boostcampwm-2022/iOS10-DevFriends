//
//  UpdateNotificationIsOKToTrueUseCase.swift
//  DevFriends
//
//  Created by 유승원 on 2022/11/22.
//

import Foundation

protocol UpdateNotificationIsOKToTrueUseCase {
    func execute(notification: Notification)
}

final class DefaultUpdateNotificationIsOKToTrueUseCase: UpdateNotificationIsOKToTrueUseCase {
    private let notificationRepository: NotificationRepository
    
    init(notificationRepository: NotificationRepository) {
        self.notificationRepository = notificationRepository
    }
    
    func execute(notification: Notification) {
        // MARK: user를 나중에 어떻게 가져올지 논의해보기
        guard let uid = UserDefaults.standard.object(forKey: "uid") as? String
        else { fatalError("UID was not stored!!") }
        notificationRepository.update(isOK: true, userID: uid, notification: notification)
    }
}
