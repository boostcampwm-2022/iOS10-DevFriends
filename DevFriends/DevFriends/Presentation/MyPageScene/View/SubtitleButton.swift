//
//  SubtitleButton.swift
//  DevFriends
//
//  Created by 심주미 on 2022/11/22.
//

import UIKit

class SubtitleButton: UIButton {
    
    init(text: String) {
        super.init(frame: .zero)
        configureUI(text: text)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI(text: String) {
        var config = UIButton.Configuration.plain()
        config.title = text
        config.baseForegroundColor = .devFriendsBase
        self.configuration = config
        self.configuration?.contentInsets = .zero
    }
}
