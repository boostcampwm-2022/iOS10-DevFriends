//
//  ContainsProfile.swift
//  DevFriends
//
//  Created by 심주미 on 2022/11/16.
//

import Combine
import SnapKit
import UIKit

protocol ContainsProfile: UIView {
    var nameSubject: PassthroughSubject<String?, Error> { get set }
    var imageSubject: PassthroughSubject<Data?, Error> { get set }
    var cancellables: Set<AnyCancellable> { get set }
}

extension ContainsProfile {
    func makeProfileView(messageLabel: MessageLabel) {
        let profileImageViewHeight: CGFloat = 50
        let profileImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.layer.cornerRadius = profileImageViewHeight / 2
            imageView.layer.masksToBounds = true
            imageView.tintColor = .orange
            return imageView
        }()
        
        let nameLabel: UILabel = {
            let label = UILabel()
            label.font = .systemFont(ofSize: 13, weight: .bold)
            return label
        }()
        
        self.layout(
            nameLabel: nameLabel,
            profileImageView: profileImageView,
            profileImageViewHeight: profileImageViewHeight
        )
        self.bind(nameLabel: nameLabel, profileImageView: profileImageView)
    }
    
    func layout(nameLabel: UILabel, profileImageView: UIImageView, profileImageViewHeight: CGFloat) {
        self.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.top).offset(10)
            make.leading.equalTo(profileImageView.snp.trailing).offset(10)
        }
        
        self.addSubview(profileImageView)
        profileImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
            make.size.height.width.equalTo(profileImageViewHeight)
        }
    }
    
    func bind(nameLabel: UILabel, profileImageView: UIImageView) {
        self.nameSubject.sink { _ in
        } receiveValue: { name in
            if let name = name {
                nameLabel.isHidden = false
                nameLabel.text = name
            } else {
                nameLabel.isHidden = true
            }
        }
        .store(in: &cancellables)
        
        self.imageSubject.sink { _ in
        } receiveValue: { image in
            if let image = image {
                profileImageView.isHidden = false
                profileImageView.image = UIImage(data: image)
            } else {
                profileImageView.isHidden = true
            }
        }
        .store(in: &cancellables)
    }
}
