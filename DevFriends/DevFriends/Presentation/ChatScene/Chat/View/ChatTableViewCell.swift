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
    private let chatImageView = UIImageView()
    
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
    
    private let newMessageLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .red
        label.textColor = .white
        label.layer.cornerRadius = 10
        label.textAlignment = .center
        label.clipsToBounds = true
        label.font = .systemFont(ofSize: 12)
        return label
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
    
    func set(data: AcceptedGroup) {
        self.participantCountLabel.text = "\(data.group.participantIDs.count)"
        self.titleLabel.text = data.group.title
        self.lastMessageLabel.text = data.lastMessageContent
        if data.newMessageCount == 0 {
            self.newMessageLabel.isHidden = true
        } else {
            self.newMessageLabel.isHidden = false
            if data.newMessageCount > 9 {
                self.newMessageLabel.text = "9+"
            } else {
                self.newMessageLabel.text = "\(data.newMessageCount)"
            }
        }
        setImage(group: data.group)
    }
    
    func setImage(group: Group) {
        let groupType = GroupType(rawValue: group.type)
        switch groupType {
        case .project:
            chatImageView.image = .project
        case .mogakco:
            chatImageView.image = .mogakco
        case .study:
            chatImageView.image = .study
        default:
            chatImageView.image = .devFriends
        }
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
        
        self.addSubview(newMessageLabel)
        self.newMessageLabel.snp.makeConstraints { make in
            make.centerY.equalTo(self.chatImageView.snp.centerY)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(20)
            make.width.greaterThanOrEqualTo(25)
        }
        self.newMessageLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        self.addSubview(lastMessageLabel)
        self.lastMessageLabel.snp.makeConstraints { make in
            make.bottom.equalTo(self.chatImageView.snp.bottom).offset(-10)
            make.leading.equalTo(self.chatImageView.snp.trailing).offset(20)
            make.trailing.equalTo(self.newMessageLabel.snp.leading).offset(-10)
        }
        
        self.addSubview(participantCountLabel)
        self.participantCountLabel.snp.makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp.top)
            make.leading.equalTo(self.titleLabel.snp.trailing).offset(10)
            make.trailing.lessThanOrEqualTo(self.newMessageLabel.snp.leading).offset(-10)
        }
    }
}
