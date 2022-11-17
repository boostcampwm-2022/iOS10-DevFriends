//
//  CommonButton.swift
//  DevFriends
//
//  Created by 유승원 on 2022/11/16.
//

import UIKit

final class CommonButton: UIButton {
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(text: String) {
        super.init(frame: .zero)
        
        self.setTitle(text, for: .normal)
        self.style()
    }
    
    private func style() {
        self.backgroundColor = UIColor(red: 0.992, green: 0.577, blue: 0.277, alpha: 1)
        self.titleLabel?.font = .systemFont(ofSize: 25)
        self.layer.cornerRadius = 15
    }
}
