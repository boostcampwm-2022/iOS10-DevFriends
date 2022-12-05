//
//  NotificationRepository.swift
//  DevFriends
//
//  Created by 유승원 on 2022/11/22.
//

protocol NotificationRepository {
    func create(to uid: String, notification: Notification)
    func fetch(uid: String) async throws -> [Notification]
    func update(isAccepted: Bool, userID: String, notification: Notification)
    func delete(userID: String, notificationID: String)
}
