//
//  Notification.swift
//  DevFriends
//
//  Created by 유승원 on 2022/11/21.
//

import Foundation
import FirebaseFirestoreSwift

// MARK: NotificationResponseDTO로 바꿔보자
struct Notification: Codable, Hashable {
    @DocumentID var uid: String?
    let image: Data?
    let groupID: String
    let groupTitle: String
    let senderID: String?
    let senderNickname: String?
    let type: String
    var isOK: Bool?
    
    init(image: Data? = nil, groupID: String, groupTitle: String, senderID: String? = nil, senderNickname: String? = nil, type: String, isOK: Bool? = nil) {
        self.image = image
        self.groupID = groupID
        self.groupTitle = groupTitle
        self.senderID = senderID
        self.senderNickname = senderNickname
        self.type = type
        self.isOK = isOK
    }
}
