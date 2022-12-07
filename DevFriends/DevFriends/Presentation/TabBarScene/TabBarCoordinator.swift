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
    func makeMogakcoSceneDIContainer() -> MogakcoSceneDIContainer
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
        navigationController?.pushViewController(tabBarController, animated: false)
        tabBarController.tabBar.tintColor = .orange

        let chatSceneNavigationController = UINavigationController()
        let groupSceneNavigationController = UINavigationController()
        let mogakcoSceneNavigationController = UINavigationController()
        let myPageNavigationController = UINavigationController()
        tabBarController.viewControllers = [
            mogakcoSceneNavigationController,
            groupSceneNavigationController,
            chatSceneNavigationController,
            myPageNavigationController
        ]
        
        startGroupScene(groupSceneNavigationController: groupSceneNavigationController)
        startChatScene(chatSceneNavigationController: chatSceneNavigationController)
        startMogakcoScene(mogakcoSceneNavigationController: mogakcoSceneNavigationController)
        startMyPageScene(myPageNavigationController: myPageNavigationController)
    }
    
    func startMogakcoScene(mogakcoSceneNavigationController: UINavigationController) {
        mogakcoSceneNavigationController.tabBarItem.image = .map
        mogakcoSceneNavigationController.tabBarItem.title = "모각코"
        let mogakcoSceneDIContainer = dependencies.makeMogakcoSceneDIContainer()
        let flow = mogakcoSceneDIContainer.makeMogakcoFlowCoordinator(
            navigationController: mogakcoSceneNavigationController
        )
        flow.start()
        childCoordinators.append(flow)
    }
    
    func startGroupScene(groupSceneNavigationController: UINavigationController) {
        groupSceneNavigationController.tabBarItem.image = .book
        groupSceneNavigationController.tabBarItem.title = "모임"
        let groupSceneDIContainer = dependencies.makeGroupSceneDIContainer()
        let flow = groupSceneDIContainer.makeGroupFlowCoordinator(navigationController: groupSceneNavigationController)
        flow.start()
        childCoordinators.append(flow)
    }
    
    func startChatScene(chatSceneNavigationController: UINavigationController) {
        chatSceneNavigationController.tabBarItem.image = .message
        chatSceneNavigationController.tabBarItem.title = "채팅"
        let chatSceneDIContainer = dependencies.makeChatSceneDIContainer()
        let flow = chatSceneDIContainer.makeChatFlowCoordinator(navigationController: chatSceneNavigationController)
        flow.start()
        childCoordinators.append(flow)
    }
        
    func startMyPageScene(myPageNavigationController: UINavigationController) {
        myPageNavigationController.tabBarItem.image = .person
        myPageNavigationController.tabBarItem.title = "마이페이지"
        let myPageSceneDIContainer = dependencies.makeMyPageSceneDIContainer()
        let flow = myPageSceneDIContainer.makeMyPageCoordinator(navigationController: myPageNavigationController)
        flow.start()
        childCoordinators.append(flow)
    }
}
