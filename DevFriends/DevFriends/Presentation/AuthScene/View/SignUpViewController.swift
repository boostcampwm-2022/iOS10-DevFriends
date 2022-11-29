//
//  SignUpViewController.swift
//  DevFriends
//
//  Created by 유승원 on 2022/11/28.
//

import Combine
import SnapKit
import UIKit

final class SignUpViewController: DefaultViewController {
    let emailTextField: CommonTextField = {
        let textField = CommonTextField(placeHolder: nil)
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor(red: 0.463, green: 0.463, blue: 0.463, alpha: 1).cgColor
        textField.layer.cornerRadius = 10
        return textField
    }()
    let emailValidationLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    let nicknameTextField: CommonTextField = {
        let textField = CommonTextField(placeHolder: nil)
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor(red: 0.463, green: 0.463, blue: 0.463, alpha: 1).cgColor
        textField.layer.cornerRadius = 10
        return textField
    }()
    let nicknameValidationLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    let categorySelectionView: ChooseCategoryView = {
        let categorySelectionView = ChooseCategoryView()
        return categorySelectionView
    }()
    let signUpButton: CommonButton = {
        let button = CommonButton(text: "회원가입")
        button.set(title: "양식을 작성해주세요", state: .disabled)
        return button
    }()
    
    private let viewModel: SignUpViewModel
    
    init(signUpViewModel: SignUpViewModel) {
        self.viewModel = signUpViewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        
        view.addSubview(emailValidationLabel)
        emailValidationLabel.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(6)
            make.left.equalToSuperview().offset(21)
        }
        
        let nicknameLabel = makeTitleLabel(text: "닉네임")
        view.addSubview(nicknameLabel)
        nicknameLabel.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(32)
            make.left.equalToSuperview().offset(21)
        }
        
        view.addSubview(nicknameTextField)
        nicknameTextField.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel.snp.bottom).offset(6)
            make.left.right.equalToSuperview().inset(12)
            make.height.equalTo(38)
        }
        
        view.addSubview(nicknameValidationLabel)
        nicknameValidationLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameTextField.snp.bottom).offset(6)
            make.left.equalToSuperview().offset(21)
        }
        
        view.addSubview(categorySelectionView)
        categorySelectionView.snp.makeConstraints { make in
            make.top.equalTo(nicknameTextField.snp.bottom).offset(27)
            make.left.right.equalToSuperview().inset(20)
        }
        
        view.addSubview(signUpButton)
        signUpButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-45)
            make.left.right.equalToSuperview().inset(17)
            make.height.equalTo(48)
        }
    }
    
    override func bind() {
        let isProcessEnabled = PassthroughSubject<Bool, Never>()
        let isEmailEntered = PassthroughSubject<Bool, Never>()
        let isNicknameEntered = PassthroughSubject<Bool, Never>()
        
        emailTextField.publisher(for: \.text)
            .print()
            .map { self.isValidEmail(of: $0) }
            .handleEvents(receiveOutput: {
                switch $0 {
                case true:
                    self.emailValidationLabel.text = "사용할 수 있는 이메일입니다."
                    self.emailValidationLabel.textColor = .systemGreen
                case false:
                    self.emailValidationLabel.text = "이메일 형식이 올바르지 않습니다."
                    self.emailValidationLabel.textColor = .systemRed
                }
            })
            .subscribe(isEmailEntered)
            .store(in: &cancellables)
        
        nicknameTextField.publisher(for: \.text)
            .map { !($0?.isEmpty ?? true) }
            .subscribe(isNicknameEntered)
            .store(in: &cancellables)
        
        Publishers.CombineLatest(isEmailEntered, isNicknameEntered)
            .map { $0 && $1 }
            .subscribe(isProcessEnabled)
            .store(in: &cancellables)
        
        isProcessEnabled
            .sink {
                switch $0 {
                case true:
                    self.signUpButton.set(title: "회원가입", state: .activated)
                case false:
                    self.signUpButton.set(title: "양식을 작성해주세요", state: .disabled)
                }
            }
            .store(in: &cancellables)
        
        viewModel.emailSubject
            .compactMap { $0 }
            .sink {
                self.emailTextField.text = $0
            }
            .store(in: &cancellables)
        
        viewModel.nameSubject
            .sink {
                self.nicknameTextField.text = $0
            }
            .store(in: &cancellables)
    }
    
    private func makeTitleLabel(text: String) -> UILabel {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.text = text
        return label
    }
    
    func isValidEmail(of email: String?) -> Bool {
        guard let email = email else { return false }
        let emailRegEx = "[0-9a-z._%+-]+@[a-z0-9.-]+\\.[a-z]{2,64}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
}
