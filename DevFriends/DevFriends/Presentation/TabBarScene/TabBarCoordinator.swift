//
//  TabBarCoordinator.swift
//  DevFriends
//
//  Created by 심주미 on 2022/11/23.
//

import UIKit

protocol TabBarFlowCoordinatorDependencies {
    func makeTabBarController(actions: TabBarViewModelActions) -> TabBarController
    func makeChatSceneDIContainer() -> ChatSceneDIContainer
}

final class TabBarCoordinator: Coordinator {
    let dependencies: TabBarFlowCoordinatorDependencies
    private weak var navigationController: UINavigationController?
    var childCoordinators: [Coordinator] = []
    let chatSceneNavigationController = UINavigationController()
    
    init(dependencies: TabBarFlowCoordinatorDependencies, navigationController: UINavigationController) {
        self.dependencies = dependencies
        self.navigationController = navigationController
    }
    
    func start() {
        let actions = TabBarViewModelActions(setChat: showChatViewController)
        let tabBarController = dependencies.makeTabBarController(actions: actions)
        tabBarController.viewControllers = [chatSceneNavigationController]
        navigationController?.pushViewController(tabBarController, animated: false)
    }
    
    func showChatViewController() {
        chatSceneNavigationController.tabBarItem.image = UIImage(systemName: "message")
        let chatSceneDIContainer = dependencies.makeChatSceneDIContainer()
        let flow = chatSceneDIContainer.makeChatFlowCoordinator(navigationController: chatSceneNavigationController)
        flow.start()
        childCoordinators.append(flow)
    }
}
