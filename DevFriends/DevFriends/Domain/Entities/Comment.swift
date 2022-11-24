//
//  Comment.swift
//  DevFriends
//
//  Created by 상현 on 2022/11/21.
//

import Foundation

struct Comment: Codable {
    let content: String
    let time: Date
    let userID: String
}
