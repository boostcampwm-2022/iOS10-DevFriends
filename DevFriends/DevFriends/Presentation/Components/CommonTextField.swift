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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(placeHolder: String?) {
        super.init(frame: .zero)
        
        self.placeholder = placeHolder
        
        style()
    }
    
    private func style() {
        font = .systemFont(ofSize: 20)
        leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: frame.height))
        leftViewMode = .always
    }
}
