//
//  BackBarButtonItem.swift
//  DevFriends
//
//  Created by 심주미 on 2022/12/05.
//

import UIKit

class BackBarButtonItem: UIBarButtonItem {
    override init() {
        super.init()
        image = .chevronLeft
        style = .plain
        tintColor = .devFriendsBase
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
