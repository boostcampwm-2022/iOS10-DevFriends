//
//  MessageLabel.swift
//  DevFriends
//
//  Created by 심주미 on 2022/11/15.
//

import UIKit

final class MessageLabel: UILabel {
    private var padding = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    
    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.height += padding.top + padding.bottom
        contentSize.width += padding.left + padding.right

        return contentSize
    }
    
    init(type: MessageSenderType) {
        super.init(frame: .zero)
        self.setup()
        self.fillColor(type: type)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: self.padding))
    }
    
    private func setup() {
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 15
        self.layer.masksToBounds = true
        self.numberOfLines = 0
    }
    
    private func fillColor(type: MessageSenderType) {
        self.layer.borderColor = UIColor.orange.cgColor
        switch type {
        case .friend:
            self.backgroundColor = .white
            self.textColor = .black
        case .me:
            self.backgroundColor = .orange
            self.textColor = .white
        }
    }
}
