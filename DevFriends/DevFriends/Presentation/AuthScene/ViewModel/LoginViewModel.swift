//
//  LoginViewController.swift
//  DevFriends
//
//  Created by 유승원 on 2022/11/29.
//

import AuthenticationServices
import UIKit

struct LoginViewModelActions {
    let showSignUp: (_ uid: String, _ email: String?, _ name: String?) -> Void
    // let showTabBar: () -> Void
}

protocol LoginViewModelInput {
//    func didSelectLoginButton()
    func didLoginCompleted(uid: String, email: String?, name: String?) async
}
protocol LoginViewModelOutput {}

protocol LoginViewModel: LoginViewModelInput, LoginViewModelOutput {}

final class DefaultLoginViewModel: LoginViewModel {
    private let checkUserUseCase: CheckUserUseCase
    private let actions: LoginViewModelActions?
    
    init(actions: LoginViewModelActions, checkUserUseCase: CheckUserUseCase) {
        self.actions = actions
        self.checkUserUseCase = checkUserUseCase
    }
}

// MARK: INPUT
extension DefaultLoginViewModel {
//    func didSelectLoginButton() {
//        let appleIDProvider = ASAuthorizationAppleIDProvider()
//        let request = appleIDProvider.createRequest()
//        request.requestedScopes = [.fullName, .email]
//
//        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
//        authorizationController.delegate = self
//        authorizationController.presentationContextProvider = self
//        authorizationController.performRequests()
//    }
    
    func didLoginCompleted(uid: String, email: String?, name: String?) async {
        // 애플 로그인 버튼을 누르고 그 이후의 로직을 담당
        // 1. firestore의 User 컬렉션에 해당 uid를 가진 document가 있는지 확인
        let task = Task { () -> Bool in
            try await self.checkUserUseCase.execute(uid: uid)
        }
        
        let result = await task.result
        do {
            let isExist = try result.get()
            if isExist {
                // TODO: user를 이용해서 UserManager를 만들 예정(showTabBar에 User 인자를 전달해도 좋을듯?)
//                actions?.showTabBar() // 2. 있으면 -> 탭 바로 이동
            } else {
                DispatchQueue.main.async {
                    self.actions?.showSignUp(uid, email, name) // 2. 없으면 -> SignUp VC로 이동
                }
            }
        } catch {
            print(error)
        }
    }
}
