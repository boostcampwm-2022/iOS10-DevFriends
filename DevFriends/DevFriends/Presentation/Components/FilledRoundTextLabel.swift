//
//  FilledRoundTextLabel.swift
//  DevFriends
//
//  Created by 유승원 on 2022/11/14.
//

import UIKit

final class FilledRoundTextLabel: UILabel {
    private var padding = UIEdgeInsets(top: 3.0, left: 6.5, bottom: 3.0, right: 6.5)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Init Error")
    }
    
    init(text: String, backgroundColor: UIColor, textColor: UIColor) {
        super.init(frame: .zero)
        
        style(text: text, backgroundColor: backgroundColor, textColor: textColor)
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }
    
    func style(text: String, backgroundColor: UIColor, textColor: UIColor) {
        self.text = text
        self.layer.cornerRadius = 10
        self.backgroundColor = backgroundColor
        self.textColor = textColor
        self.clipsToBounds = true
        self.layer.cornerRadius = 8
        self.textAlignment = .center
        self.font = .boldSystemFont(ofSize: 10)
    }
    
    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.height += padding.top + padding.bottom
        contentSize.width += padding.left + padding.right
        
        return contentSize
    }
}
