//
//  ChatTableViewCell.swift
//  DevFriends
//
//  Created by 심주미 on 2022/11/14.
//
import UIKit
import SnapKit

final class ChatTableViewCell: UITableViewCell {
    private let chatImageViewHeight: CGFloat = 70
    private lazy var chatImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .gray
        imageView.layer.cornerRadius = self.chatImageViewHeight / 2
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .bold)
        return label
    }()
    
    private let participantCountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .lightGray
        return label
    }()
    
    private let lastMessageLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.textColor = .gray
        return label
    }()
    
    private let newMessageView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        view.layer.cornerRadius = 10
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.titleLabel.text = ""
        self.participantCountLabel.text = ""
        self.lastMessageLabel.text = ""
    }
    
    func set(data: Group, lastMessage: String?, hasNewMessage: Bool) {
        self.participantCountLabel.text = "\(data.participantIDs.count)"
        self.titleLabel.text = data.title
        self.lastMessageLabel.text = lastMessage
        self.newMessageView.isHidden = !hasNewMessage
    }
}

extension ChatTableViewCell: ReusableType {
    static var reuseIdentifier = String(describing: ChatTableViewCell.self)
    
    func layout() {
        self.addSubview(chatImageView)
        self.chatImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.bottom.lessThanOrEqualToSuperview().offset(-15)
            make.leading.equalToSuperview().offset(20)
            make.size.height.width.equalTo(chatImageViewHeight)
        }
        
        self.addSubview(titleLabel)
        self.titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.chatImageView.snp.top).offset(10)
            make.leading.equalTo(self.chatImageView.snp.trailing).offset(20)
        }
        
        self.addSubview(newMessageView)
        self.newMessageView.snp.makeConstraints { make in
            make.centerY.equalTo(self.chatImageView.snp.centerY)
            make.trailing.equalToSuperview().offset(-20)
            make.size.height.width.equalTo(20)
        }
        
        self.addSubview(lastMessageLabel)
        self.lastMessageLabel.snp.makeConstraints { make in
            make.bottom.equalTo(self.chatImageView.snp.bottom).offset(-10)
            make.leading.equalTo(self.chatImageView.snp.trailing).offset(20)
            make.trailing.equalTo(self.newMessageView.snp.leading).offset(-10)
        }
        
        self.addSubview(participantCountLabel)
        self.participantCountLabel.snp.makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp.top)
            make.leading.equalTo(self.titleLabel.snp.trailing).offset(10)
            make.trailing.lessThanOrEqualTo(self.newMessageView.snp.leading).offset(-10)
        }
    }
}
