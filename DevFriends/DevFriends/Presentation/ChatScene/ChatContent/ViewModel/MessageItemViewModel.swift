//
//  MessageItemViewModel.swift
//  DevFriends
//
//  Created by 유승원 on 2022/11/20.
//

import Foundation

struct MessageItemViewModel {
    let content: String
    let time: Date
    let userID: String
}

extension MessageItemViewModel {
    init(message: Message) {
        self.content = message.content
        self.time = message.time
        self.userID = message.userID
    }
}
