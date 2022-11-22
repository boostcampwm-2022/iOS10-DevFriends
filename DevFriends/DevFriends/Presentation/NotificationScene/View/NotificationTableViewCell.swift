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
    
    func layout() {}
    
    func updateContent(data: Notification) {
        var content = defaultContentConfiguration()
        
        content.text = data.groupTitle
        content.textProperties.font = .boldSystemFont(ofSize: 14)
        content.secondaryTextProperties.font = .systemFont(ofSize: 14)
        content.textToSecondaryTextVerticalPadding = 10.0
        content.image = UIImage.profile
        
        switch data.type {
        case "joinRequest":
            guard let senderNickname = data.senderNickname, let isOK = data.isOK else { return }
            content.secondaryText = "\(senderNickname)의 참여 요청"
            setButton(isSelected: isOK)
        case "joinWait":
            content.secondaryText = "참여 신청이 완료되었습니다."
        case "joinSuccess":
            content.secondaryText = "모임에 가입되셨습니다!"
        default:
            break
        }
        
        self.contentConfiguration = content
    }
    
    private func setButton(isSelected status: Bool) {
        self.addSubview(acceptButton)
        self.acceptButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-20)
        }
        if isSelected {
            var config = self.acceptButton.configuration ?? UIButton.Configuration.filled()
            config.title = "승인됨"
            config.baseBackgroundColor = UIColor(red: 0.851, green: 0.851, blue: 0.851, alpha: 1)
            self.acceptButton.configuration = config
        }
    }
}
