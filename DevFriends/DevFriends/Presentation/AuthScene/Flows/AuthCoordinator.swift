//
//  AuthCoordinator.swift
//  DevFriends
//
//  Created by 유승원 on 2022/11/29.
//

import UIKit

protocol AuthFlowCoordinatorDependencies {
    func makeLoginViewController(actions: LoginViewModelActions) -> LoginViewController
    func makeSignUpViewController(actions: SignUpViewModelActions, uid: String, email: String?, name: String?) -> SignUpViewController
}

final class AuthCoordinator: Coordinator {
    private weak var navigationController: UINavigationController?
    let dependencies: AuthFlowCoordinatorDependencies
    
    init(navigationController: UINavigationController, dependencies: AuthFlowCoordinatorDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        let actions = LoginViewModelActions(showSignUp: showSignUpViewController)
        let loginViewController = dependencies.makeLoginViewController(actions: actions)
        navigationController?.pushViewController(loginViewController, animated: false)
    }
    
    func showSignUpViewController(_ uid: String, _ email: String?, _ name: String?) {
        let actions = SignUpViewModelActions()
        let signUpViewController = dependencies.makeSignUpViewController(
            actions: actions,
            uid: uid,
            email: email,
            name: name
        )
        navigationController?.pushViewController(signUpViewController, animated: false)
    }
}
