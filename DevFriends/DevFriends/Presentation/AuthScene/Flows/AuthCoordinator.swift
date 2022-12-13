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
    func makeCategoryViewController(actions: ChooseCategoryViewModelActions, initFilter: [Category]?) -> ChooseCategoryViewController
}

protocol AuthCoordinatorDelegate: AnyObject {
    func showTabBar()
}

final class AuthCoordinator: Coordinator {
    private weak var navigationController: UINavigationController?
    let dependencies: AuthFlowCoordinatorDependencies
    weak var delegate: AuthCoordinatorDelegate?
    
    init(navigationController: UINavigationController, dependencies: AuthFlowCoordinatorDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        if UserManager.shared.isEnabledAutoLogin {
            delegate?.showTabBar()
        } else {
            self.showLoginViewController()
        }
    }
    
    func showLoginViewController() {
        guard let showTabBarController = delegate?.showTabBar else { fatalError("Auth Delegate is not linked.") }
        let actions = LoginViewModelActions(
            showSignUp: showSignUpViewController,
            showTabBarController: showTabBarController
        )
        let loginViewController = dependencies.makeLoginViewController(actions: actions)
        navigationController?.pushViewController(loginViewController, animated: false)
    }
    
    func showSignUpViewController(_ uid: String, _ email: String?, _ name: String?) {
        guard let showTabBarController = delegate?.showTabBar else { fatalError("Auth Delegate is not linked.") }
        let actions = SignUpViewModelActions(
            showTabBarController: showTabBarController,
            moveBackToPrevViewController: moveBackToLoginViewController,
            showCategoryView: showCategoryViewController
        )
        let signUpViewController = dependencies.makeSignUpViewController(
            actions: actions,
            uid: uid,
            email: email,
            name: name
        )
        navigationController?.pushViewController(signUpViewController, animated: false)
    }
    
    func moveBackToLoginViewController() {
        navigationController?.popViewController(animated: true)
    }
    
    func showCategoryViewController(initFilter: [Category]?) {
        let actions = ChooseCategoryViewModelActions(didSubmitCategory: didSubmitCategorySelection)
        let categoryViewController = dependencies.makeCategoryViewController(actions: actions, initFilter: initFilter)
        navigationController?.pushViewController(categoryViewController, animated: true)
    }
    
    func didSubmitCategorySelection(updatedCategories: [Category]) {
        navigationController?.popViewController(animated: true)
        guard let viewController = navigationController?.viewControllers.last as? SignUpViewController else { return }
        viewController.updateCategories(categories: updatedCategories)
    }
}
