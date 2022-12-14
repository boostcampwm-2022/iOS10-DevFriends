//
//  Notification.swift
//  DevFriends
//
//  Created by 유승원 on 2022/11/21.
//

import Foundation

struct Notification: Hashable {
    let uid: String?
    let groupID: String
    let groupTitle: String
    let senderID: String?
    let senderNickname: String?
    let commentID: String?
    let comment: String?
    let type: NotificationType
    var isAccepted: Bool?
    let time: Date?
    
    init(
        uid: String? = nil,
        groupID: String,
        groupTitle: String,
        senderID: String? = nil,
        senderNickname: String? = nil,
        commentID: String? = nil,
        comment: String? = nil,
        type: NotificationType,
        isAccepted: Bool? = nil,
        time: Date? = nil
    ) {
        self.uid = uid
        self.groupID = groupID
        self.groupTitle = groupTitle
        self.senderID = senderID
        self.senderNickname = senderNickname
        self.commentID = commentID
        self.comment = comment
        self.type = type
        self.isAccepted = isAccepted
        self.time = time
    }
}
