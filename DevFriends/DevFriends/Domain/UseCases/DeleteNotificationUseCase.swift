//
//  DeleteNotificationUseCase.swift
//  DevFriends
//
//  Created by 유승원 on 2022/11/23.
//

import Foundation

protocol DeleteNotificationUseCase {
    func execute(notification: Notification)
}

final class DefaultDeleteNotificationUseCase: DeleteNotificationUseCase {
    private let notificationRepository: NotificationRepository
    
    init(notificationRepository: NotificationRepository) {
        self.notificationRepository = notificationRepository
    }
    
    func execute(notification: Notification) {
        // MARK: user를 나중에 어떻게 가져올지 논의해보기
        guard let uid = UserDefaults.standard.object(forKey: "uid") as? String
        else { fatalError("UID was not stored!!") }
        notificationRepository.delete(userID: uid, notification: notification)
    }
}
