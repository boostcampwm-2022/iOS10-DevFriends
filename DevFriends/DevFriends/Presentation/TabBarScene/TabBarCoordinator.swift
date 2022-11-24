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
    func makeMyPageSceneDIContainer() -> MyPageSceneDIContainer
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
        let myPageNavigationController = UINavigationController()
        tabBarController.viewControllers = [chatSceneNavigationController, myPageNavigationController]
        navigationController?.pushViewController(tabBarController, animated: false)
        startChatScene(chatSceneNavigationController: chatSceneNavigationController)
        startMyPageScene(myPageNavigationController: myPageNavigationController)
    }
    
    func startChatScene(chatSceneNavigationController: UINavigationController) {
        chatSceneNavigationController.tabBarItem.image = UIImage(systemName: "message")
        let chatSceneDIContainer = dependencies.makeChatSceneDIContainer()
        let flow = chatSceneDIContainer.makeChatFlowCoordinator(navigationController: chatSceneNavigationController)
        flow.start()
        childCoordinators.append(flow)
    }
    
    func startMyPageScene(myPageNavigationController: UINavigationController) {
        myPageNavigationController.tabBarItem.image = UIImage(systemName: "person")
        let myPageSceneDIContainer = dependencies.makeMyPageSceneDIContainer()
        let flow = myPageSceneDIContainer.makeMyPageCoordinator(navigationController: myPageNavigationController)
        flow.start()
        childCoordinators.append(flow)
    }
}
