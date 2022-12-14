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
    let showTabBarController: () -> Void
}

protocol LoginViewModelInput {
    func didLoginCompleted(uid: String, email: String?, name: String?) async
}
protocol LoginViewModelOutput {}

protocol LoginViewModel: LoginViewModelInput, LoginViewModelOutput {}

final class DefaultLoginViewModel: LoginViewModel {
    private let checkUserUseCase: CheckUserUseCase
    private let actions: LoginViewModelActions
    
    init(actions: LoginViewModelActions, checkUserUseCase: CheckUserUseCase) {
        self.actions = actions
        self.checkUserUseCase = checkUserUseCase
    }
}

// MARK: INPUT
extension DefaultLoginViewModel {
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
                UserManager.shared.login(uid: uid)
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
                    self.actions.showTabBarController() // 2. 있으면 -> 탭 바로 이동
                }
            } else {
                DispatchQueue.main.async {
                    self.actions.showSignUp(uid, email, name) // 2. 없으면 -> SignUp VC로 이동
                }
            }
        } catch {
            print(error)
        }
    }
    
    func saveUIDToKeyChain(uid: String) {
        // TODO: 키체인에 uid 저장하기
    }
}
