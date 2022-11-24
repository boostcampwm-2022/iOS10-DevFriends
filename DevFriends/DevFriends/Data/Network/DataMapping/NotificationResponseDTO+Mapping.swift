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
    let commentID: String?
    let comment: String?
    let type: String
    let isAccepted: Bool?
}

extension NotificationResponseDTO {
    func toDamain() -> Notification {
        return Notification(
            uid: self.uid,
            groupID: self.groupID,
            groupTitle: self.groupTitle,
            senderID: self.senderID,
            senderNickname: self.senderNickname,
            commentID: self.commentID,
            comment: self.comment,
            type: self.type,
            isAccepted: self.isAccepted
        )
    }
}
