//
//  SignUpViewController.swift
//  DevFriends
//
//  Created by 유승원 on 2022/11/28.
//

import SnapKit
import UIKit

final class SignUpViewController: DefaultViewController {
    let emailTextField: UITextField = {
        let textField = UITextField()
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor(red: 0.463, green: 0.463, blue: 0.463, alpha: 1).cgColor
        textField.layer.cornerRadius = 10
        return textField
    }()
    let nicknameTextField: UITextField = {
        let textField = UITextField()
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor(red: 0.463, green: 0.463, blue: 0.463, alpha: 1).cgColor
        textField.layer.cornerRadius = 10
        return textField
    }()
    let categorySelectionView: ChooseCategoryView = {
        let categorySelectionView = ChooseCategoryView()
        return categorySelectionView
    }()
    
    override func configureUI() {

    }

    override func layout() {
        let emailLabel = makeTitleLabel(text: "이메일")
        view.addSubview(emailLabel)
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(8)
            make.left.equalToSuperview().offset(21)
        }
        
        view.addSubview(emailTextField)
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(emailLabel.snp.bottom).offset(6)
            make.left.right.equalToSuperview().inset(12)
            make.height.equalTo(38)
        }
        
        let nicknameLabel = makeTitleLabel(text: "닉네임")
        view.addSubview(nicknameLabel)
        nicknameLabel.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(12)
            make.left.equalToSuperview().offset(21)
        }
        
        view.addSubview(nicknameTextField)
        nicknameTextField.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel.snp.bottom).offset(6)
            make.left.right.equalToSuperview().inset(12)
            make.height.equalTo(38)
        }
        
        view.addSubview(categorySelectionView)
        categorySelectionView.snp.makeConstraints { make in
            make.top.equalTo(nicknameTextField.snp.bottom).offset(27)
            make.left.right.equalToSuperview().inset(20)
        }
    }

    override func bind() {

    }
    
    private func makeTitleLabel(text: String) -> UILabel {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.text = text
        return label
    }
}

