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
    lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.frame = CGRect(x: 0.0, y: 0.0, width: 40, height: 40)
        return imageView
    }()
    lazy var subStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.distribution = .fill
        return stackView
    }()
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "알림 제목"
        label.font = .boldSystemFont(ofSize: 14)
        label.textColor = .black
        label.sizeToFit()
        return label
    }()
    lazy var secondaryTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "알림 설명"
        label.font = .systemFont(ofSize: 14)
        label.textColor = .black
        label.sizeToFit()
        return label
    }()
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
        button
            .publisher(for: .touchUpInside)
            .sink {
                self.setButton(isAccepted: true)
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
    static var reuseIdentifier = String(describing: NotificationTableViewCell.self)
    
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
        profileImageView.image = UIImage.profile?.resize(newWidth: 40)
        
        let notificationType = NotificationType.init(rawValue: data.type)
        switch notificationType {
        case .joinRequest:
            guard let senderNickname = data.senderNickname, let isOK = data.isOK else { return }
            self.secondaryTitleLabel.text = "\(senderNickname)의 참여 요청"
            self.setButton(isAccepted: isOK)
        case .joinWait:
            self.secondaryTitleLabel.text = "참여 신청이 완료되었습니다."
        case .joinSuccess:
            self.secondaryTitleLabel.text = "모임에 가입되셨습니다!"
        case .unknown:
            break
        }
    }
    
    private func setButton(isAccepted status: Bool) {
        self.contentView.addSubview(acceptButton)
        self.acceptButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-20)
        }
        
        if status {
            var config = self.acceptButton.configuration ?? UIButton.Configuration.filled()
            var titleAttr = AttributedString.init("승인됨")
            titleAttr.font = .boldSystemFont(ofSize: 12)
            config.attributedTitle = titleAttr
            config.baseBackgroundColor = UIColor(red: 0.851, green: 0.851, blue: 0.851, alpha: 1)
            self.acceptButton.configuration = config
            self.acceptButton.isUserInteractionEnabled = false
        }
    }
}
