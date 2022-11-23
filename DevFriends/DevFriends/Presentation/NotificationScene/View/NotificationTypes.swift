//
//  NotificationTypes.swift
//  DevFriends
//
//  Created by 유승원 on 2022/11/23.
//

import Foundation

// TODO: 이런 파일은 어디에 놓아야 될지 논의해보기
enum NotificationType: String {
    case joinRequest
    case joinWait
    case joinSuccess
    case unknown
    
    init(rawValue: String) {
        switch rawValue {
        case "joinRequest": self = .joinRequest
        case "joinWait": self = .joinWait
        case "joinSuccess": self = .joinSuccess
        default: self = .unknown
        }
    }
}

enum NotificationJoinType {
    case accepted
    case denied
}
