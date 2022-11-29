//
//  SignUpViewModel.swift
//  DevFriends
//
//  Created by 유승원 on 2022/11/29.
//

import Combine
import Foundation

struct SignUpViewModelActions {}

protocol SignUpViewModelInput {}
protocol SignUpViewModelOutput {
    var emailSubject: CurrentValueSubject<String?, Never> { get }
    var nameSubject: CurrentValueSubject<String?, Never> { get }
}

protocol SignUpViewModel: SignUpViewModelInput, SignUpViewModelOutput {}

final class DefaultSignUpViewModel: SignUpViewModel {
    private let actions: SignUpViewModelActions?
    
    private let uid: String
    var emailSubject = CurrentValueSubject<String?, Never>(nil)
    var nameSubject = CurrentValueSubject<String?, Never>(nil)
    
    
    
    init(actions: SignUpViewModelActions?, uid: String, email: String? = nil, name: String? = nil) {
        self.actions = actions
        self.uid = uid
        self.emailSubject.send(email)
        self.nameSubject.send(name)
    }
}
