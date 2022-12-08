//
//  CommonPaddingLabel.swift
//  DevFriends
//
//  Created by 이대현 on 2022/11/27.
//

import UIKit

final class CommonPaddingLabel: UILabel {
    var padding = UIEdgeInsets(top: 16.0, left: 16.0, bottom: 16.0, right: 16.0)
    
    convenience init(padding: UIEdgeInsets) {
        self.init()
        self.padding = padding
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }
    
    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.height += padding.top + padding.bottom
        contentSize.width += padding.left + padding.right
        
        return contentSize
    }
}
