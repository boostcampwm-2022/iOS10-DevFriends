//
//  ChatSceneDIContainer.swift
//  DevFriends
//
//  Created by 심주미 on 2022/11/15.
//

import UIKit

struct ChatSceneDIContainer {
    func makeChatDetailFlowCoordinator(navigationController: UINavigationController) -> ChatDetailFlowCoordinator {
        return ChatDetailFlowCoordinator(navigationController: navigationController, dependencies: self)
    }
}

extension ChatSceneDIContainer: ChatDetailFlowCoordinatorDependencies {
    
    //MARK: Chat Content
    func makeChatContentViewController(group: Group) -> ChatContentViewController {
        return ChatContentViewController(group: group)
    }
}
