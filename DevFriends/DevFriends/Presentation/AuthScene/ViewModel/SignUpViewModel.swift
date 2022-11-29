//
//  SignUpViewModel.swift
//  DevFriends
//
//  Created by 유승원 on 2022/11/29.
//

import Combine
import Foundation

struct SignUpViewModelActions {}

protocol SignUpViewModelInput {
    func didTouchedSignUp(nickname: String, job: String, email: String)
}

protocol SignUpViewModelOutput {
    var emailSubject: CurrentValueSubject<String?, Never> { get }
    var nameSubject: CurrentValueSubject<String?, Never> { get }
}

protocol SignUpViewModel: SignUpViewModelInput, SignUpViewModelOutput {}

final class DefaultSignUpViewModel: SignUpViewModel {
    private let actions: SignUpViewModelActions?
    private let createUserUseCase: CreateUserUseCase
    
    private let uid: String
    var emailSubject = CurrentValueSubject<String?, Never>(nil)
    var nameSubject = CurrentValueSubject<String?, Never>(nil)
    
    init(actions: SignUpViewModelActions?, createUserUseCase: CreateUserUseCase, uid: String, email: String? = nil, name: String? = nil) {
        self.actions = actions
        self.createUserUseCase = createUserUseCase
        self.uid = uid
        self.emailSubject.send(email)
        self.nameSubject.send(name)
    }
}

// MARK: INPUT
extension DefaultSignUpViewModel {
    func didTouchedSignUp(nickname: String, job: String, email: String) {
        // 1. CreateUserUseCase를 통해 Firestore 쪽에 document를 만든다
        self.createUserUseCase.execute(uid: self.uid, nickname: nickname, job: job, email: email)
        // 2. UserManager에게 User를 전달하고 UserManager에서는 해당 document를 Listen한다
        // 3. UserManager를 필요로하는 곳에 의존성을 주입한다
    }
}
