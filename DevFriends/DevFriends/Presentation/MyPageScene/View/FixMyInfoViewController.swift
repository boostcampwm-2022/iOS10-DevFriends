//
//  FixMyInfoViewController.swift
//  DevFriends
//
//  Created by 심주미 on 2022/11/22.
//

import UIKit

class FixMyInfoViewController: DefaultViewController {
    lazy var profileImageViewHeight = view.frame.width - 100
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .profile
        imageView.layer.cornerRadius = profileImageViewHeight / 2
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private lazy var nicknameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "닉네임을 입력해주세요 or 사용자 이름"
        return textField
    }()
    
    private lazy var fixDoneButton = CommonButton(text: "수정 완료")
    
    func makeTitleLabel(text: String) -> UILabel {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.text = text
        return label
    }
    
    override func layout() {
        view.addSubview(profileImageView)
        profileImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.width.height.equalTo(profileImageViewHeight)
        }
        
        let nicknameLabel = makeTitleLabel(text: "닉네임")
        view.addSubview(nicknameLabel)
        nicknameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(25)
            make.top.equalTo(profileImageView.snp.bottom).offset(25)
        }
        
        view.addSubview(nicknameTextField)
        nicknameTextField.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(25)
            make.trailing.equalToSuperview().offset(-25)
            make.top.equalTo(nicknameLabel.snp.bottom).offset(15)
        }
        
        view.addSubview(fixDoneButton)
        fixDoneButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalToSuperview().offset(25)
            make.trailing.equalToSuperview().offset(-25)
            make.height.equalTo(40)
        }
    }
}
