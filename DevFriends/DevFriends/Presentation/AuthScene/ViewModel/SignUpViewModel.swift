//
//  SignUpViewModel.swift
//  DevFriends
//
//  Created by 유승원 on 2022/11/29.
//

import Combine
import Foundation

struct SignUpViewModelActions {
    let showTabBarController: () -> Void
    let moveBackToPrevViewController: () -> Void
    let showChooseCategoryViewController: () -> Void
}

protocol SignUpViewModelInput {
    func viewDidLoad()
    func didTouchedSignUp(nickname: String, job: String?, email: String)
    func didChangedTextInEmailTextField(text: String?)
    func didChangedTextInNicknameTextField(text: String?)
    func didTouchedBackButton()
    func didTouchedCategoryView()
}

protocol SignUpViewModelOutput {
    var email: String? { get }
    var name: String? { get }
    var isProcessEnabled: PassthroughSubject<Bool, Never> { get }
    var isEmailValidated: PassthroughSubject<Bool, Never> { get }
}

protocol SignUpViewModel: SignUpViewModelInput, SignUpViewModelOutput {}

final class DefaultSignUpViewModel: SignUpViewModel {
    private var cancellables = Set<AnyCancellable>()
    
    private let actions: SignUpViewModelActions
    private let createUserUseCase: CreateUserUseCase
    
    private let uid: String
    let email: String?
    let name: String?
    
    let isProcessEnabled = PassthroughSubject<Bool, Never>()
    let isEmailValidated = PassthroughSubject<Bool, Never>()
    let isNicknameValidated = PassthroughSubject<Bool, Never>()
    
    init(actions: SignUpViewModelActions, createUserUseCase: CreateUserUseCase, uid: String, email: String? = nil, name: String? = nil) {
        self.actions = actions
        self.createUserUseCase = createUserUseCase
        self.uid = uid
        self.email = email
        self.name = name
    }
}

// MARK: INPUT
extension DefaultSignUpViewModel {
    func viewDidLoad() {
        Publishers.CombineLatest(isEmailValidated, isNicknameValidated)
            .map {
                $0 && $1
            }
            .subscribe(isProcessEnabled)
            .store(in: &cancellables)
    }
    
    func didTouchedSignUp(nickname: String, job: String?, email: String) {
        self.createUserUseCase.execute(
            uid: self.uid,
            nickname: nickname,
            job: job ?? "",
            email: email
        ) { error in
            if let error = error {
                print(error)
                return
            }
            
            UserManager.shared.login(uid: self.uid)
            self.actions.showTabBarController()
        }
    }
    
    func didChangedTextInEmailTextField(text: String?) {
        self.isEmailValidated.send(isValidEmail(of: text))
    }
    
    func didChangedTextInNicknameTextField(text: String?) {
        guard let text = text else { return }
        // TODO: 닉네임 유효성 검사 진행하기
        if !text.isEmpty {
            self.isNicknameValidated.send(true)
        } else {
            self.isNicknameValidated.send(false)
        }
    }
    
    func didTouchedBackButton() {
        actions.moveBackToPrevViewController()
    }
    
    func didTouchedCategoryView() {
        actions.showChooseCategoryViewController()
    }
}

// MARK: Private
extension DefaultSignUpViewModel {
    private func isValidEmail(of email: String?) -> Bool {
        guard let email = email else { return false }
        let emailRegEx = "[0-9a-z._%+-]+@[a-z0-9.-]+\\.[a-z]{2,64}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
}
