//
//  ChatTableViewCell.swift
//  DevFriends
//
//  Created by 심주미 on 2022/11/14.
//

import UIKit
import SnapKit

class ChatTableViewCell: UITableViewCell, CellType {
    
    static var reuseIdentifier = String(describing: ChatTableViewCell.self)
    let chatImageViewHegiht: CGFloat = 70
    lazy var chatImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .gray
        imageView.layer.cornerRadius = chatImageViewHegiht / 2
        self.addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(15)
            $0.bottom.equalToSuperview().offset(-15)
            $0.leading.equalToSuperview().offset(20)
            $0.size.height.width.equalTo(chatImageViewHegiht)
        }
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .bold)
        
        self.addSubview(label)
        label.snp.makeConstraints {
            $0.top.equalTo(self.chatImageView.snp.top).offset(10)
            $0.leading.equalTo(self.chatImageView.snp.trailing).offset(20)
        }
        return label
    }()
    
    lazy var participantCountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .lightGray
        
        self.addSubview(label)
        label.snp.makeConstraints {
            $0.top.equalTo(self.titleLabel.snp.top)
            $0.leading.equalTo(self.titleLabel.snp.trailing).offset(10)
            $0.trailing.lessThanOrEqualTo(self.newMessageView.snp.leading).offset(-10)
        }
        
        return label
    }()
    
    lazy var lastChatContentLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.textColor = .gray
        
        self.addSubview(label)
        label.snp.makeConstraints {
            $0.bottom.equalTo(self.chatImageView.snp.bottom).offset(-10)
            $0.leading.equalTo(self.chatImageView.snp.trailing).offset(20)
            $0.trailing.equalTo(self.newMessageView.snp.leading).offset(-10)
        }
        return label
    }()
    
    lazy var newMessageView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        view.layer.cornerRadius = 10
        
        self.addSubview(view)
        view.snp.makeConstraints {
            $0.centerY.equalTo(self.chatImageView.snp.centerY)
            $0.trailing.equalToSuperview().offset(-20)
            $0.size.height.width.equalTo(20)
        }
        return view
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.titleLabel.text = ""
        self.participantCountLabel.text = ""
        self.lastChatContentLabel.text = ""
    }
    
    func updateContent(data: Group, lastContent: String?, hasNewMessage: Bool) {
        self.participantCountLabel.text = "\(data.participantIDs.count)"
        self.titleLabel.text = data.title
        self.lastChatContentLabel.text = lastContent
        self.newMessageView.isHidden = !hasNewMessage
    }
}
