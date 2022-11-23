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
    func makeTabBarViewModel(actions: TabBarViewModelActions) -> TabBarViewModel {
        return TabBarViewModel(actions: actions)
    }
    
    func makeTabBarController(actions: TabBarViewModelActions) -> TabBarController {
        return TabBarController(tabBarViewModel: makeTabBarViewModel(actions: actions))
    }
    
    func makeChatSceneDIContainer() -> ChatSceneDIContainer {
        return ChatSceneDIContainer()
    }
}
