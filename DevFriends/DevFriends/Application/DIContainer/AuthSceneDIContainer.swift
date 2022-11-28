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
    func makeLoginViewController() -> LoginViewController {
        return LoginViewController()
    }
    
    func makeSignUpViewController() -> SignUpViewController {
        return SignUpViewController()
    }
}
