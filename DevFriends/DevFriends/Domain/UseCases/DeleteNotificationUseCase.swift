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
    private let myInfoRepository: MyInfoRepository
    
    init(notificationRepository: NotificationRepository, myInfoRepository: MyInfoRepository) {
        self.notificationRepository = notificationRepository
        self.myInfoRepository = myInfoRepository
    }
    
    func execute(notification: Notification) {
        // MARK: user를 나중에 어떻게 가져올지 논의해보기
        guard let uid = myInfoRepository.uid, let notificationID = notification.uid
        else { fatalError("UID was not stored!!") }
        notificationRepository.delete(userID: uid, notificationID: notificationID)
    }
}
