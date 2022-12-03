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
    private lazy var backBarButton: UIBarButtonItem = {
        let barButton = UIBarButtonItem(
            image: .chevronLeft,
            style: .plain,
            target: self,
            action: #selector(didTouchedBackButton)
        )
        barButton.tintColor = .black
        return barButton
    }()
    let emailTextField: CommonTextField = {
        let textField = CommonTextField(placeHolder: nil)
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor(red: 0.463, green: 0.463, blue: 0.463, alpha: 1).cgColor
        textField.layer.cornerRadius = 10
        textField.keyboardType = .emailAddress
        textField.autocapitalizationType = .none
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
        textField.autocapitalizationType = .none
        return textField
    }()
    let nicknameValidationLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    let jobTextField: CommonTextField = {
        let textField = CommonTextField(placeHolder: "ex: iOS Developer")
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor(red: 0.463, green: 0.463, blue: 0.463, alpha: 1).cgColor
        textField.layer.cornerRadius = 10
        return textField
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
    
    override func viewDidLoad() {
        viewModel.viewDidLoad()
        self.setupNavigation()
        super.viewDidLoad()
    }
    
    override func configureUI() {
        hideKeyboardWhenTappedAround()
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
        
        let jobLabel = makeTitleLabel(text: "직업")
        view.addSubview(jobLabel)
        jobLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameTextField.snp.bottom).offset(32)
            make.left.equalToSuperview().offset(21)
        }
        
        view.addSubview(jobTextField)
        jobTextField.snp.makeConstraints { make in
            make.top.equalTo(jobLabel.snp.bottom).offset(6)
            make.left.right.equalToSuperview().inset(12)
            make.height.equalTo(38)
        }
        
        view.addSubview(categorySelectionView)
        categorySelectionView.snp.makeConstraints { make in
            make.top.equalTo(jobTextField.snp.bottom).offset(12)
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
        emailTextField.publisher(for: \.text)
            .sink {
                self.viewModel.didChangedTextInEmailTextField(text: $0)
            }
            .store(in: &cancellables)
        
        nicknameTextField.publisher(for: \.text)
            .sink {
                self.viewModel.didChangedTextInNicknameTextField(text: $0)
            }
            .store(in: &cancellables)
        
        viewModel.isProcessEnabled
            .sink {
                switch $0 {
                case true:
                    self.signUpButton.set(title: "회원가입", state: .activated)
                case false:
                    self.signUpButton.set(title: "양식을 작성해주세요", state: .disabled)
                }
            }
            .store(in: &cancellables)
        
        signUpButton.publisher(for: .touchUpInside)
            .sink {
                self.viewModel.didTouchedSignUp(
                    nickname: self.nicknameTextField.text ?? "",
                    job: self.jobTextField.text,
                    email: self.emailTextField.text ?? ""
                )
            }
            .store(in: &cancellables)
        
        self.emailTextField.text = self.viewModel.email
        self.nicknameTextField.text = self.viewModel.name
    }
    
    private func setupNavigation() {
        self.navigationItem.leftBarButtonItems = [backBarButton]
        self.navigationItem.title = "회원가입"
    }
    
    private func makeTitleLabel(text: String) -> UILabel {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.text = text
        return label
    }
}

extension SignUpViewController {
    @objc func didTouchedBackButton() {
        viewModel.didTouchedBackButton()
    }
}
