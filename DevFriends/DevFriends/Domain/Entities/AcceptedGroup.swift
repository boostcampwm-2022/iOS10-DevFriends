//
//  AcceptedGroup.swift
//  DevFriends
//
//  Created by 심주미 on 2022/11/28.
//

import Foundation

struct AcceptedGroup: Hashable {
    var group: Group
    let time: Date
    let lastMessageContent: String
    var newMessageCount: Int
}
