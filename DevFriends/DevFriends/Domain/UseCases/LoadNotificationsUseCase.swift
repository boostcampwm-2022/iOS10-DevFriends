//
//  LoadNotificationsUseCase.swift
//  DevFriends
//
//  Created by 유승원 on 2022/11/22.
//

import Foundation

protocol LoadNotificationsUseCase {
    func execute() async throws -> [Notification]
}

final class DefaultLoadNotificationsUseCase: LoadNotificationsUseCase {
    private let notificationRepository: NotificationRepository
    private let myInfoRepository: MyInfoRepository
    
    init(notificationRepository: NotificationRepository, myInfoRepository: MyInfoRepository) {
        self.notificationRepository = notificationRepository
        self.myInfoRepository = myInfoRepository
    }
    
    func execute() async throws -> [Notification] {
        guard let uid = myInfoRepository.uid else { fatalError("UID was not stored!!") }

        let notifications = try await notificationRepository.fetch(uid: uid)
        return notifications
    }
}
