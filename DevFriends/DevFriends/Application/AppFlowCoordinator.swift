//
//  AppFlowCoordinator.swift
//  DevFriends
//
//  Created by 심주미 on 2022/11/15.
//
import UIKit

protocol Coordinator {
    func start()
}

final class AppFlowCoordinator: Coordinator {
    let navigationController: UINavigationController
    private let appDIContainer: AppDIContainer
    
    var childCoordinators: [Coordinator] = []
    
    init(
        navigationController: UINavigationController,
        appDIContainer: AppDIContainer
    ) {
        self.navigationController = navigationController
        self.appDIContainer = appDIContainer
    }

    func start() {
        let authSceneDIContainer = appDIContainer.authSceneDIContainer()
        let flow = authSceneDIContainer.makeAuthCoordinator(navigationController: navigationController)
        
        childCoordinators.append(flow)
        flow.delegate = self
        flow.start()
    }
}

extension AppFlowCoordinator: AuthCoordinatorDelegate {
    func showTabBar() {
        navigationController.isNavigationBarHidden = true
        let tabBarSceneDIContainer = appDIContainer.tabBarSceneDIContainer()
        let flow = tabBarSceneDIContainer.makeTabBarFlowCoordinator(navigationController: navigationController)
        flow.delegate = self
        flow.start()
        childCoordinators.append(flow)
    }
}

extension AppFlowCoordinator: TabBarCoordinatorDelegate {
    func showLoginView() {
        if let flow = childCoordinators.first as? AuthCoordinator {
            childCoordinators.removeLast()
            UserManager.shared.isEnabledAutoLogin = false
            flow.start()
        }
    }
}
