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

final class ChatDetailFlowCoordinator: Coordinator {
    
    private weak var navigationController: UINavigationController?
    private let dependencies: ChatDetailFlowCoordinatorDependencies

    var childCoordinators: [Coordinator] = []
    
    init(navigationController: UINavigationController,
         dependencies: ChatDetailFlowCoordinatorDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        let chatViewController = ChatViewController(coordinator: self)
        navigationController?.pushViewController(chatViewController, animated: false)
    }
    
    func showChatContentViewController(group: Group) {
        let chatContentViewController = dependencies.makeChatContentViewController(group: group)
        navigationController?.pushViewController(chatContentViewController, animated: true)
    }
}
