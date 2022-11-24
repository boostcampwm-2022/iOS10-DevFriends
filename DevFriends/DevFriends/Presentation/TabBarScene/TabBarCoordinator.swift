//
//  TabBarCoordinator.swift
//  DevFriends
//
//  Created by 심주미 on 2022/11/23.
//

import UIKit

protocol TabBarFlowCoordinatorDependencies {
    func makeTabBarController() -> UITabBarController
    func makeChatSceneDIContainer() -> ChatSceneDIContainer
    func makeMogakcoSceneDIContainer() -> MogakcoSceneDIContainer
}

final class TabBarCoordinator: Coordinator {
    let dependencies: TabBarFlowCoordinatorDependencies
    private weak var navigationController: UINavigationController?
    var childCoordinators: [Coordinator] = []
    
    init(dependencies: TabBarFlowCoordinatorDependencies, navigationController: UINavigationController) {
        self.dependencies = dependencies
        self.navigationController = navigationController
    }
    
    func start() {
        let tabBarController = dependencies.makeTabBarController()
        let chatSceneNavigationController = UINavigationController()
//        let mogakcoSceneNavigationController = UINavigationController()
        tabBarController.viewControllers = [chatSceneNavigationController]
        navigationController?.pushViewController(tabBarController, animated: false)
        startChatScene(chatSceneNavigationController: chatSceneNavigationController)
        startMogakcoScene(navigationController: chatSceneNavigationController)
    }
    
    func startChatScene(chatSceneNavigationController: UINavigationController) {
        chatSceneNavigationController.tabBarItem.image = UIImage(systemName: "message")
        let chatSceneDIContainer = dependencies.makeChatSceneDIContainer()
        let flow = chatSceneDIContainer.makeChatFlowCoordinator(navigationController: chatSceneNavigationController)
        flow.start()
        childCoordinators.append(flow)
    }
    
    func startMogakcoScene(navigationController: UINavigationController) {
        navigationController.tabBarItem.image = UIImage(systemName: "map.fill")
        let mogakcoSceneDIContainer = dependencies.makeMogakcoSceneDIContainer()
        let flow = mogakcoSceneDIContainer.makeChatFlowCoordinator(navigationController: navigationController)
        flow.start()
        childCoordinators.append(flow)
    }
}
