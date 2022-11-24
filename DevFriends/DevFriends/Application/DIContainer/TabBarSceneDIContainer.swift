//
//  TabBarSceneDIContainer.swift
//  DevFriends
//
//  Created by 심주미 on 2022/11/23.
//

import UIKit

struct TabBarSceneDIContainer {
    func makeTabBarFlowCoordinator(navigationController: UINavigationController) -> TabBarCoordinator {
        return TabBarCoordinator(dependencies: self, navigationController: navigationController)
    }
}

extension TabBarSceneDIContainer: TabBarFlowCoordinatorDependencies {
    func makeTabBarController() -> UITabBarController {
        return UITabBarController()
    }
    
    func makeChatSceneDIContainer() -> ChatSceneDIContainer {
        return ChatSceneDIContainer()
    }
    
    func makeGroupSceneDIContainer() -> GroupSceneDIContainer {
        return GroupSceneDIContainer()
    }
}
