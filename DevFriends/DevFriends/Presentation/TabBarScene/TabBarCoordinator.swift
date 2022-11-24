//
//  TabBarCoordinator.swift
//  DevFriends
//
//  Created by 심주미 on 2022/11/23.
//

import UIKit

protocol TabBarFlowCoordinatorDependencies {
    func makeTabBarController() -> UITabBarController
    func makeGroupSceneDIContainer() -> GroupSceneDIContainer
    func makeChatSceneDIContainer() -> ChatSceneDIContainer
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
        let groupSceneNavigationController = UINavigationController()
        tabBarController.viewControllers = [
            groupSceneNavigationController,
            chatSceneNavigationController]
        navigationController?.pushViewController(tabBarController, animated: false)
        startGroupScene(groupSceneNavigationController: groupSceneNavigationController)
        startChatScene(chatSceneNavigationController: chatSceneNavigationController)
    }
    
    func startGroupScene(groupSceneNavigationController: UINavigationController) {
        groupSceneNavigationController.tabBarItem.image = UIImage(systemName: "message")
        let groupSceneDIContainer = dependencies.makeGroupSceneDIContainer()
        let flow = groupSceneDIContainer.makeGroupFlowCoordinator(navigationController: groupSceneNavigationController)
        flow.start()
        childCoordinators.append(flow)
    }
    
    func startChatScene(chatSceneNavigationController: UINavigationController) {
        chatSceneNavigationController.tabBarItem.image = UIImage(systemName: "message")
        let chatSceneDIContainer = dependencies.makeChatSceneDIContainer()
        let flow = chatSceneDIContainer.makeChatFlowCoordinator(navigationController: chatSceneNavigationController)
        flow.start()
        childCoordinators.append(flow)
    }
}
