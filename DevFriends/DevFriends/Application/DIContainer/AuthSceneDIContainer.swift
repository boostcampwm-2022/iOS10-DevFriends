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
    
    func makeCategoryRepository() -> CategoryRepository {
        return DefaultCategoryRepository()
    }
    
    func makeMyInfoRepository() -> MyInfoRepository {
        return UserManager.shared
    }
    
    private func makeCheckUserUseCase() -> CheckUserUseCase {
        return DefaultCheckUserUseCase(userRepository: makeUserRepository())
    }
    
    private func makeCreateUserUseCase() -> CreateUserUseCase {
        return DefaultCreateUserUseCase(userRepository: makeUserRepository())
    }
    
    func makeLoadCategoryUseCase() -> LoadCategoryUseCase {
        return DefaultLoadCategoryUseCase(categoryRepository: makeCategoryRepository())
    }
    
    private func makeLoginViewModel(actions: LoginViewModelActions) -> LoginViewModel {
        return DefaultLoginViewModel(
            actions: actions,
            checkUserUseCase: makeCheckUserUseCase(),
            myInfoRepository: makeMyInfoRepository()
        )
    }
    
    private func makeSignUpViewModel(actions: SignUpViewModelActions, uid: String, email: String?, name: String?) -> SignUpViewModel {
        return DefaultSignUpViewModel(
            actions: actions,
            createUserUseCase: makeCreateUserUseCase(),
            myInfoRepository: makeMyInfoRepository(),
            uid: uid,
            email: email,
            name: name
        )
    }
    
    private func makeChooseCategoryViewModel(actions: ChooseCategoryViewModelActions, initFilter: [Category]?) -> ChooseCategoryViewModel {
        return DefaultChooseCategoryViewModel(
            fetchCategoryUseCase: makeLoadCategoryUseCase(),
            actions: actions,
            initFilter: initFilter
        )
    }
    
    func makeLoginViewController(actions: LoginViewModelActions) -> LoginViewController {
        return LoginViewController(
            loginViewModel: makeLoginViewModel(actions: actions),
            myInfoRepository: makeMyInfoRepository()
        )
    }
    
    func makeSignUpViewController(actions: SignUpViewModelActions, uid: String, email: String?, name: String?) -> SignUpViewController {
        return SignUpViewController(signUpViewModel: makeSignUpViewModel(
            actions: actions,
            uid: uid,
            email: email,
            name: name
        ))
    }
    
    func makeCategoryViewController(actions: ChooseCategoryViewModelActions, initFilter: [Category]?) -> ChooseCategoryViewController {
        return ChooseCategoryViewController(
            viewModel: makeChooseCategoryViewModel(actions: actions, initFilter: initFilter)
        )
    }
}
