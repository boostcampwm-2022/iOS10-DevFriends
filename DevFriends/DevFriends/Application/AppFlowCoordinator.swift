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
    
    init(navigationController: UINavigationController,
         appDIContainer: AppDIContainer) {
        self.navigationController = navigationController
        self.appDIContainer = appDIContainer
    }

    func start() {
        let moviesSceneDIContainer = appDIContainer.makeChatSceneDIContainer()
        let flow = moviesSceneDIContainer.makeChatDetailFlowCoordinator(navigationController: navigationController)
        flow.start()
        childCoordinators.append(flow)
    }
}
