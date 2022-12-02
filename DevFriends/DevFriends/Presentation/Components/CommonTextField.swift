//
//  CommonTextField.swift
//  DevFriends
//
//  Created by 유승원 on 2022/11/16.
//

import UIKit

final class CommonTextField: UITextField {
    required init?(coder: NSCoder) {
        fatalError("Init Error")
    }
    
    init(placeHolder: String?) {
        super.init(frame: .zero)
        self.placeholder = placeHolder
        self.style()
    }
    
    private func style() {
        self.font = .systemFont(ofSize: 20)
        self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: frame.height))
        self.leftViewMode = .always
    }
}
