//
//  NotificationRepository.swift
//  DevFriends
//
//  Created by 유승원 on 2022/11/22.
//

import Foundation

protocol NotificationRepository {
    func fetch(uid: String) async throws -> [Notification]
    func send(uid: String, notification: Notification)
    func update(isOK: Bool, userID: String, notification: Notification)
}
