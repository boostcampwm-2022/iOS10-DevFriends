//
//  ChatDetailFlowCoordinator.swift
//  DevFriends
//
//  Created by 심주미 on 2022/11/15.
//

import UIKit

protocol ChatFlowCoordinatorDependencies {
    func makeChatViewController(actions: ChatViewModelActions) -> ChatViewController
    func makeChatContentViewController(group: Group, actions: ChatContentViewModelActions) -> ChatContentViewController
    func makePostReportViewController(actions: PostReportViewControllerActions) -> PostReportViewController
}

final class ChatCoordinator: Coordinator {
    let navigationController: UINavigationController
    let dependencies: ChatFlowCoordinatorDependencies

    var childCoordinators: [Coordinator] = []
    
    init(
        navigationController: UINavigationController,
        dependencies: ChatFlowCoordinatorDependencies
    ) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        let actions = ChatViewModelActions(showChatContent: showChatContentViewController)
        let chatViewController = dependencies.makeChatViewController(actions: actions)
        navigationController.pushViewController(chatViewController, animated: false)
    }
}

extension ChatCoordinator {
    func showChatContentViewController(group: Group) {
        let actions = ChatContentViewModelActions(
            back: popViewController,
            report: showPostReportViewController
        )
        let chatContentViewController = dependencies.makeChatContentViewController(group: group, actions: actions)
        navigationController.pushViewController(chatContentViewController, animated: true)
        navigationController.tabBarController?.tabBar.isHidden = true
    }
    
    func showPostReportViewController() {
        let acitons = PostReportViewControllerActions(
            submit: popViewControllerWithHiddenTabBar,
            close: popViewControllerWithHiddenTabBar
        )
        let postReportViewController = dependencies.makePostReportViewController(actions: acitons)
        navigationController.pushViewController(postReportViewController, animated: true)
    }
    
    func popViewController() {
        navigationController.popViewController(animated: true)
        navigationController.tabBarController?.tabBar.isHidden = false
    }
    
    func popViewControllerWithHiddenTabBar() {
        navigationController.popViewController(animated: true)
        navigationController.tabBarController?.tabBar.isHidden = true
    }
}
