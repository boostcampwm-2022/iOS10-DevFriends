//
//  SettingBarButtonItem.swift
//  DevFriends
//
//  Created by 심주미 on 2022/12/06.
//

import UIKit

class SettingBarButtonItem: UIBarButtonItem {
    override init() {
        super.init()
        image = .ellipsis
        tintColor = .devFriendsBase
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
