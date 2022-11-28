//
//  LoginViewController.swift
//  DevFriends
//
//  Created by 유승원 on 2022/11/28.
//

import AuthenticationServices
import SnapKit
import UIKit

final class LoginViewController: DefaultViewController {
    let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo")
        return imageView
    }()
    let mainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "person.3")
        imageView.tintColor = .orange
        return imageView
    }()
    let highlightLabel: UILabel = {
        let label = UILabel()
        label.text = "나만의 개발친구를 만들어봐요!"
        label.numberOfLines = 1
        label.font = .boldSystemFont(ofSize: 26)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.textAlignment = .center
        return label
    }()
    let appleLoginButton: ASAuthorizationAppleIDButton = {
        let button = ASAuthorizationAppleIDButton(type: .signIn, style: .black)
        return button
    }()
    let termsLabel: UILabel = {
        let label = UILabel()
        label.text = "계속 진행하여, DevFriends 서비스 약관 그리고 개인 정보 보호 정책에 동의하세요."
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = UIColor(red: 0.446, green: 0.435, blue: 0.435, alpha: 1)
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    
    override func configureUI() {
        
    }
    
    override func layout() {
        view.addSubview(logoImageView)
        logoImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(66)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalTo(logoImageView.snp.width).dividedBy(6.47)
        }
        
        view.addSubview(mainImageView)
        mainImageView.snp.makeConstraints { make in
            make.top.equalTo(logoImageView.snp.bottom).offset(54)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.7)
            make.height.equalTo(mainImageView.snp.width)
        }
        
        view.addSubview(highlightLabel)
        highlightLabel.snp.makeConstraints { make in
            make.top.equalTo(mainImageView.snp.bottom).offset(27)
            make.left.right.equalToSuperview().inset(31)
            make.height.equalTo(highlightLabel.snp.width).dividedBy(11)
        }
        
        view.addSubview(appleLoginButton)
        appleLoginButton.snp.makeConstraints { make in
            make.top.equalTo(highlightLabel.snp.bottom).offset(45)
            make.left.right.equalToSuperview().inset(17)
            make.height.equalTo(56)
        }
        
        view.addSubview(termsLabel)
        termsLabel.snp.makeConstraints { make in
            make.top.equalTo(appleLoginButton.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(24)
        }
        
        highlightLabel.adjustsFontSizeToFitWidth = true
    }
    override func bind() {
        
    }
}
