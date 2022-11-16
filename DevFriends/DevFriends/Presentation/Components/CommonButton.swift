//
//  CommonButton.swift
//  DevFriends
//
//  Created by 유승원 on 2022/11/16.
//

import UIKit

final class CommonButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(text: String) {
        super.init(frame: .zero)
        
        setTitle(text, for: .normal)
        style()
    }
    
    private func style() {
        backgroundColor = UIColor(red: 0.992, green: 0.577, blue: 0.277, alpha: 1)
        titleLabel?.font = .systemFont(ofSize: 25)
        layer.cornerRadius = 15
    }
}
