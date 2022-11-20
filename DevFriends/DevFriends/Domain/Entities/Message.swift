//
//  Message.swift
//  DevFriends
//
//  Created by 심주미 on 2022/11/15.
//

import Foundation
import FirebaseFirestoreSwift

struct Message: Codable, Hashable {
    @DocumentID var uid: String?
    let content: String
    let time: Date
    let userID: String
    let userNickname: String
}
