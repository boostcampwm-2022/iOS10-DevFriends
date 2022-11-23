//
//  NotificationResponseDTO+Mapping.swift
//  DevFriends
//
//  Created by 유승원 on 2022/11/22.
//

import Foundation
import FirebaseFirestoreSwift

struct NotificationResponseDTO: Codable {
    @DocumentID var uid: String?
    let groupID: String
    let groupTitle: String
    let senderID: String?
    let senderNickname: String?
    let type: String
    let isOK: Bool?
}

extension NotificationResponseDTO {
    func toDamain() -> Notification {
        return Notification(
            uid: self.uid,
            groupID: self.groupID,
            groupTitle: self.groupTitle,
            senderID: self.senderID,
            senderNickname: self.senderNickname,
            type: self.type,
            isOK: self.isOK
        )
    }
}
