//
//  NotificationTableViewCell.swift
//  DevFriends
//
//  Created by 유승원 on 2022/11/21.
//

import Combine
import SnapKit
import UIKit

final class NotificationTableViewCell: UITableViewCell {
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.frame = CGRect(x: 0.0, y: 0.0, width: 40, height: 40)
        return imageView
    }()
    let subStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.distribution = .fill
        return stackView
    }()
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "알림 제목"
        label.font = .boldSystemFont(ofSize: 14)
        label.textColor = .devFriendsBase
        label.sizeToFit()
        return label
    }()
    let secondaryTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "알림 설명"
        label.font = .systemFont(ofSize: 14)
        label.textColor = .devFriendsBase
        label.sizeToFit()
        return label
    }()
    lazy var acceptButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.filled()
        var titleAttr = AttributedString.init("승인")
        titleAttr.font = .boldSystemFont(ofSize: 12)
        config.attributedTitle = titleAttr
        config.baseBackgroundColor = .devFriendsOrange
        config.cornerStyle = .capsule
        config.contentInsets = NSDirectionalEdgeInsets(top: 6.0, leading: 13.0, bottom: 6.0, trailing: 13.0)
        button.configuration = config
        button
            .publisher(for: .touchUpInside)
            .sink { [weak self] in
                self?.setButton(isAccepted: true)
            }
            .store(in: &cancellables)
        return button
    }()
    
    private var cancellables = Set<AnyCancellable>()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension NotificationTableViewCell: ReusableType {
    func layout() {
        self.addSubview(profileImageView)
        profileImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(18)
            make.centerY.equalToSuperview()
            make.height.width.equalTo(40)
        }
        self.addSubview(subStackView)
        subStackView.snp.makeConstraints { make in
            make.left.equalTo(profileImageView.snp.right).offset(26)
            make.centerY.equalToSuperview()
        }
        subStackView.addArrangedSubview(titleLabel)
        subStackView.addArrangedSubview(secondaryTitleLabel)
    }
    
    func updateContent(data: Notification) {
        titleLabel.text = data.groupTitle
        profileImageView.image = UIImage.defaultProfileImage?.resize(newWidth: 40)
        
        let notificationType = data.type
        switch notificationType {
        case .joinRequest:
            guard let senderNickname = data.senderNickname, let isAccepted = data.isAccepted else { return }
            self.secondaryTitleLabel.text = "\(senderNickname)의 참여 요청"
            self.setButton(isAccepted: isAccepted)
        case .joinWait:
            self.secondaryTitleLabel.text = "참여 신청이 완료되었습니다."
        case .joinSuccess:
            self.secondaryTitleLabel.text = "모임에 가입되셨습니다!"
        case .comment:
            guard let senderNickname = data.senderNickname else { return }
            self.secondaryTitleLabel.text = "\(senderNickname)님이 댓글을 남기셨습니다."
        case .unknown:
            break
        }
    }
    
    private func setButton(isAccepted status: Bool) {
        self.contentView.addSubview(acceptButton)
        self.acceptButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(28)
            make.width.equalTo(59)
        }
        
        if status {
            var config = self.acceptButton.configuration ?? UIButton.Configuration.filled()
            var titleAttr = AttributedString.init("승인됨")
            titleAttr.font = .boldSystemFont(ofSize: 12)
            config.attributedTitle = titleAttr
            config.baseBackgroundColor = .devFriendsGray
            self.acceptButton.configuration = config
            self.acceptButton.isUserInteractionEnabled = false
        }
    }
}
