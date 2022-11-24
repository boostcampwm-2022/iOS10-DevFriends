//
//  NotificationRepository.swift
//  DevFriends
//
//  Created by 유승원 on 2022/11/22.
//

import Foundation

protocol NotificationRepository {
    func fetch(uid: String) async throws -> [Notification]
    func send(to uid: String, notification: Notification)
    func update(isAccepted: Bool, userID: String, notification: Notification)
    func delete(userID: String, notificationID: String)
}
