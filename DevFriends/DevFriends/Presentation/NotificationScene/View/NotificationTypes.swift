//
//  NotificationTypes.swift
//  DevFriends
//
//  Created by 유승원 on 2022/11/23.
//

import Foundation

enum NotificationType: String {
    case joinRequest
    case joinWait
    case joinSuccess
    case comment
    case unknown
    
    init(rawValue: String) {
        switch rawValue {
        case "joinRequest": self = .joinRequest
        case "joinWait": self = .joinWait
        case "joinSuccess": self = .joinSuccess
        case "comment": self = .comment
        default: self = .unknown
        }
    }
}

enum NotificationJoinType {
    case accepted
    case denied
}
