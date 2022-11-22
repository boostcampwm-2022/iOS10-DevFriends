//
//  NotificationTableViewCell.swift
//  DevFriends
//
//  Created by 유승원 on 2022/11/21.
//

import SnapKit
import UIKit

final class NotificationTableViewCell: UITableViewCell {
    lazy var acceptButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.filled()
        var titleAttr = AttributedString.init("승인")
        titleAttr.font = .boldSystemFont(ofSize: 12)
        config.attributedTitle = titleAttr
        config.baseBackgroundColor = UIColor(red: 0.992, green: 0.577, blue: 0.277, alpha: 1)
        config.cornerStyle = .capsule
        config.contentInsets = NSDirectionalEdgeInsets(top: 6.0, leading: 18.0, bottom: 6.0, trailing: 18.0)
        button.configuration = config
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension NotificationTableViewCell: ReusableType {
    static var reuseIdentifier = String(describing: NotificationTableViewCell.self)
    
    func layout() {
        self.addSubview(acceptButton)
        self.acceptButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-20)
        }
    }
    
    func updateContent(data: Notification) {
        var content = defaultContentConfiguration()
        
        content.text = data.title
        content.textProperties.font = .boldSystemFont(ofSize: 14)
        content.secondaryText = data.subTitle
        content.secondaryTextProperties.font = .systemFont(ofSize: 14)
        content.textToSecondaryTextVerticalPadding = 10.0
        content.image = UIImage.profile
        
        self.contentConfiguration = content
    }
}
