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
    let type: String
    var isOK: Bool?
    
    init(
        uid: String? = nil,
        groupID: String,
        groupTitle: String,
        senderID: String? = nil,
        senderNickname: String? = nil,
        commentID: String? = nil,
        comment: String? = nil,
        type: String,
        isOK: Bool? = nil
    ) {
        self.uid = uid
        self.groupID = groupID
        self.groupTitle = groupTitle
        self.senderID = senderID
        self.senderNickname = senderNickname
        self.commentID = commentID
        self.comment = comment
        self.type = type
        self.isOK = isOK
    }
}
