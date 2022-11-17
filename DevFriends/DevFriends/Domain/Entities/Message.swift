//
//  Message.swift
//  DevFriends
//
//  Created by 심주미 on 2022/11/15.
//

import Foundation

struct Message: Hashable {
    let content: String
    let time: Date
    let userID: String
}
