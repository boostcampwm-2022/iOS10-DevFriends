//
//  DefaultNotificationRepository.swift
//  DevFriends
//
//  Created by 유승원 on 2022/11/22.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

final class DefaultNotificationRepository: ContainsFirestore {}

extension DefaultNotificationRepository: NotificationRepository {
    func fetch(uid: String) async throws -> [Notification] {
        let snapshot = try await firestore.collection("User").document(uid).collection("Notification").getDocuments()
        
        let notifications = try snapshot.documents.map{ try $0.data(as: Notification.self) }
        
        return notifications
    }
    
    func send(uid: String, notification: Notification) {
        do {
            _ = try firestore
                .collection("User")
                .document(uid)
                .collection("Notification")
                .addDocument(from: notification)
        } catch {
            print(error)
        }
    }
    
    func update(isOK: Bool, userID: String, notification: Notification) {
        guard let notificationID = notification.uid else { fatalError("notification UID is nil") }
        var notification = notification
        notification.isOK = true
        
        if isOK {
            do {
                try firestore
                    .collection("User")
                    .document(userID)
                    .collection("Notification")
                    .document(notificationID)
                    .setData(from: notification)
            } catch {
                print(error)
            }
        }
    }
}
