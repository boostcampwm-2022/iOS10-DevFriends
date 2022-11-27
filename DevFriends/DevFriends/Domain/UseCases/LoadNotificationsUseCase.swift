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
        // MARK: user를 나중에 어떻게 가져올지 논의해보기
        guard let uid = UserDefaults.standard.object(forKey: "uid") as? String
        else { fatalError("UID was not stored!!") }
        let notifications = try await notificationRepository.fetch(uid: uid)
        return notifications
    }
}
