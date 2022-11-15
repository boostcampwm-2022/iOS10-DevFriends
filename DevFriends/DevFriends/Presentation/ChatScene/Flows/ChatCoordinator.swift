//
//  ChatDetailFlowCoordinator.swift
//  DevFriends
//
//  Created by 심주미 on 2022/11/15.
//

import UIKit

protocol ChatDetailFlowCoordinatorDependencies  {
    func makeChatContentViewController(group: Group) -> ChatContentViewController
}

final class ChatCoordinator: Coordinator {
    
    private weak var navigationController: UINavigationController?
    let dependencies: ChatDetailFlowCoordinatorDependencies

    var childCoordinators: [Coordinator] = []
    
    init(navigationController: UINavigationController,
         dependencies: ChatDetailFlowCoordinatorDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        let chatViewController = ChatViewController()
        chatViewController.coordinator = self
        navigationController?.pushViewController(chatViewController, animated: false)
    }
}

extension ChatCoordinator: ChatViewCoordinator {
    func showChatContentViewController(group: Group) {
        let chatContentViewController = dependencies.makeChatContentViewController(group: group)
        navigationController?.pushViewController(chatContentViewController, animated: true)
    }
}
