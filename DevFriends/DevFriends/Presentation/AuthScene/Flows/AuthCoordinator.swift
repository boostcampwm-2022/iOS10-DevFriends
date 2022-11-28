//
//  AuthCoordinator.swift
//  DevFriends
//
//  Created by 유승원 on 2022/11/29.
//

import UIKit

protocol AuthFlowCoordinatorDependencies {
    func makeLoginViewController() -> LoginViewController
    func makeSignUpViewController() -> SignUpViewController
}

final class AuthCoordinator: Coordinator {
    private weak var navigationController: UINavigationController?
    let dependencies: AuthFlowCoordinatorDependencies
    
    init(navigationController: UINavigationController, dependencies: AuthFlowCoordinatorDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        let loginViewController = dependencies.makeLoginViewController()
        navigationController?.pushViewController(loginViewController, animated: false)
    }
    
    func showSignUpViewController() {
        let signUpViewController = dependencies.makeSignUpViewController()
        navigationController?.pushViewController(signUpViewController, animated: true)
    }
}
