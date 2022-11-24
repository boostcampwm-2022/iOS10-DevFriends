//
//  CommonButton.swift
//  DevFriends
//
//  Created by 유승원 on 2022/11/16.
//

import UIKit

enum CommonButtonType {
    case fill
    case none
}

final class CommonButton: UIButton {
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(text: String, type: CommonButtonType = .fill) {
        super.init(frame: .zero)
        
        self.setTitle(text, for: .normal)
        self.style(type: type)
    }
    
    private func style(type: CommonButtonType) {
        self.titleLabel?.font = .systemFont(ofSize: 22)
        self.layer.cornerRadius = 10
        switch type {
        case .fill:
            self.backgroundColor = .devFriendsOrange
        case .none:
            self.layer.borderWidth = 1
            self.layer.borderColor = UIColor.darkGray.cgColor
            self.backgroundColor = .white
            self.setTitleColor(.darkGray, for: .normal)
        }
    }
}
