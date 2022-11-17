//
//  DividerView.swift
//  DevFriends
//
//  Created by 유승원 on 2022/11/16.
//

import UIKit
import SnapKit

final class DividerView: UIView {
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() {
        super.init(frame: .zero)
        
        self.style()
    }
    
    private func style() {
        self.backgroundColor = UIColor(red: 0.921, green: 0.898, blue: 0.898, alpha: 1)
        self.snp.makeConstraints { make in
            make.height.equalTo(1)
        }
    }
}
