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
    var navigationController: UINavigationController
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
        navigationController.isNavigationBarHidden = true
        let tabBarSceneDIContainer = appDIContainer.tabBarSceneDIContainer()
        let flow = tabBarSceneDIContainer.makeTabBarFlowCoordinator(navigationController: navigationController)
        flow.start()
        childCoordinators.append(flow)
    }
}
