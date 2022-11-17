//
//  MessageCellType.swift
//  DevFriends
//
//  Created by 심주미 on 2022/11/15.
//

import Combine
import SnapKit
import UIKit

enum MessageSenderType {
    case friend
    case me
}

enum MessageContentType {
    case profile
    case time
    case profileAndTime
    case none
}

protocol MessageCellType: CellType {
    var messageLabel: MessageLabel {get set}
}
