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
    
    init(notificationRepository: NotificationRepository) {
        self.notificationRepository = notificationRepository
    }
    
    func execute() async throws -> [Notification] {
        guard let uid = UserManager.shared.uid else { fatalError("UID was not stored!!") }

        let notifications = try await notificationRepository.fetch(uid: uid)
        return notifications
    }
}
