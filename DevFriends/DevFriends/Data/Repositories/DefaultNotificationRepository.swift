//
//  DefaultNotificationRepository.swift
//  DevFriends
//
//  Created by 유승원 on 2022/11/22.
//

import Foundation
import FirebaseFirestore

final class DefaultNotificationRepository: ContainsFirestore {}

extension DefaultNotificationRepository: NotificationRepository {
    func fetch(uid: String) async throws -> [Notification] {
        let snapshot = try await firestore.collection("User").document(uid).collection("Notification").getDocuments()
        
        let notifications = try snapshot.documents.map{ try $0.data(as: Notification.self) }
        
        return notifications
    }
    
    func send(uid: String, notification: Notification) {}
}
