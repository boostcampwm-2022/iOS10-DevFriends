//
//  ChatDetailFlowCoordinator.swift
//  DevFriends
//
//  Created by 심주미 on 2022/11/15.
//

import UIKit

protocol ChatFlowCoordinatorDependencies {
    func makeChatViewController(actions: ChatViewModelActions) -> ChatViewController
    func makeChatContentViewController(group: Group) -> ChatContentViewController
}

final class ChatCoordinator: Coordinator {
    private weak var navigationController: UINavigationController?
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
        navigationController?.pushViewController(chatViewController, animated: false)
    }
}

extension ChatCoordinator: ChatViewCoordinator {
    func showChatContentViewController(group: Group) {
        let chatContentViewController = dependencies.makeChatContentViewController(group: group)
        navigationController?.pushViewController(chatContentViewController, animated: true)
    }
}
