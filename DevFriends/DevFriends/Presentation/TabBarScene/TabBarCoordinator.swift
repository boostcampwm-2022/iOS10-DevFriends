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
        startMogakcoScene(navigationController: mogakcoSceneNavigationController)
        startMyPageScene(myPageNavigationController: myPageNavigationController)
    }
    
    func startGroupScene(groupSceneNavigationController: UINavigationController) {
        groupSceneNavigationController.tabBarItem.image = UIImage(systemName: "text.book.closed.fill")
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
    
    func startMogakcoScene(navigationController: UINavigationController) {
        navigationController.tabBarItem.image = UIImage(systemName: "map.fill")
        let mogakcoSceneDIContainer = dependencies.makeMogakcoSceneDIContainer()
        let flow = mogakcoSceneDIContainer.makeChatFlowCoordinator(navigationController: navigationController)
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
