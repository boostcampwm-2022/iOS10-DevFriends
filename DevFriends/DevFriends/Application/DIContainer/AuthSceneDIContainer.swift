//
//  AuthSceneDIContainer.swift
//  DevFriends
//
//  Created by 유승원 on 2022/11/29.
//

import UIKit

struct AuthSceneDIContainer {
    func makeAuthCoordinator(navigationController: UINavigationController) -> AuthCoordinator {
        return AuthCoordinator(navigationController: navigationController, dependencies: self)
    }
}

extension AuthSceneDIContainer: AuthFlowCoordinatorDependencies {
    private func makeUserRepository() -> UserRepository {
        return DefaultUserRepository()
    }
    
    private func makeCheckUserUseCase() -> CheckUserUseCase {
        return DefaultCheckUserUseCase(userRepository: makeUserRepository())
    }
    
    private func makeCreateUserUseCase() -> CreateUserUseCase {
        return DefaultCreateUserUseCase(userRepository: makeUserRepository())
    }
    
    private func makeLoginViewModel(actions: LoginViewModelActions) -> LoginViewModel {
        return DefaultLoginViewModel(actions: actions, checkUserUseCase: makeCheckUserUseCase())
    }
    
    private func makeSignUpViewModel(actions: SignUpViewModelActions, uid: String, email: String?, name: String?) -> SignUpViewModel {
        return DefaultSignUpViewModel(
            actions: actions,
            createUserUseCase: makeCreateUserUseCase(),
            uid: uid,
            email: email,
            name: name
        )
    }
    
    func makeLoginViewController(actions: LoginViewModelActions) -> LoginViewController {
        return LoginViewController(loginViewModel: makeLoginViewModel(actions: actions))
    }
    
    func makeSignUpViewController(actions: SignUpViewModelActions, uid: String, email: String?, name: String?) -> SignUpViewController {
        return SignUpViewController(signUpViewModel: makeSignUpViewModel(
            actions: actions,
            uid: uid,
            email: email,
            name: name
        ))
    }
}
