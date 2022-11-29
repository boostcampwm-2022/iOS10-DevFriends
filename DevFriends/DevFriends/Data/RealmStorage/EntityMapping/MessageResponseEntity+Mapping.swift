//
//  MessageResponseEntity+Mapping.swift
//  DevFriends
//
//  Created by 심주미 on 2022/11/29.
//

import RealmSwift

class MessageResponseEntity: Object {
    @objc dynamic var groupID: String = ""
    @objc dynamic var content: String = ""
    @objc dynamic var time: Date = .now
    @objc dynamic var userID: String = ""
    @objc dynamic var userNickname: String = ""
}

extension MessageResponseEntity {
    func toDomain() -> Message {
        return Message(
            content: content,
            time: time,
            userID: userID,
            userNickname: userNickname
        )
    }
}
