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
        let snapshot = try await firestore
            .collection("User")
            .document(uid)
            .collection("Notification")
            .getDocuments()
        
        let notifications = try snapshot.documents
            .map { try $0.data(as: NotificationResponseDTO.self) }
            .map { $0.toDamain() }
        
        return notifications
    }
    
    func send(to uid: String, notification: Notification) {
        let notificationResponseDTO = self.makeNotificationResponseDTO(notification: notification)
        
        do {
            _ = try firestore
                .collection("User")
                .document(uid)
                .collection("Notification")
                .addDocument(from: notificationResponseDTO)
        } catch {
            print(error)
        }
    }
    
    func update(isAccepted: Bool, userID: String, notification: Notification) {
        guard let notificationID = notification.uid else { fatalError("notification UID is nil") }
        var notification = notification
        notification.isAccepted = true
        
        let notificationResponseDTO = self.makeNotificationResponseDTO(notification: notification)
        
        if isAccepted {
            do {
                try firestore
                    .collection("User")
                    .document(userID)
                    .collection("Notification")
                    .document(notificationID)
                    .setData(from: notificationResponseDTO)
            } catch {
                print(error)
            }
        }
    }
    
    func delete(userID: String, notificationID: String) {
        firestore
            .collection("User")
            .document(userID)
            .collection("Notification")
            .document(notificationID)
            .delete()
    }
}

// MARK: Private
extension DefaultNotificationRepository {
    private func makeNotificationResponseDTO(notification: Notification) -> NotificationResponseDTO {
        return NotificationResponseDTO(
            groupID: notification.groupID,
            groupTitle: notification.groupTitle,
            senderID: notification.senderID,
            senderNickname: notification.senderNickname,
            commentID: notification.commentID,
            comment: notification.comment,
            type: notification.type.rawValue,
            isAccepted: notification.isAccepted
        )
    }
}
