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
    enum ButtonState {
        case activated
        case disabled
    }
    
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
    
    func set(title: String, state: ButtonState) {
        self.setTitle(title, for: .normal)
        switch state {
        case .activated:
            self.backgroundColor = UIColor(red: 0.992, green: 0.577, blue: 0.277, alpha: 1)
            self.isEnabled = true
        case .disabled:
            self.backgroundColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
            self.isEnabled = false
        }
    }
}
