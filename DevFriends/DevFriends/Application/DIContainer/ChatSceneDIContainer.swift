//
//  ChatSceneDIContainer.swift
//  DevFriends
//
//  Created by 심주미 on 2022/11/15.
//

import UIKit

struct ChatSceneDIContainer {
    // MARK: Flow Coordinators
    func makeChatFlowCoordinator(navigationController: UINavigationController) -> ChatCoordinator {
        return ChatCoordinator(navigationController: navigationController, dependencies: self)
    }
}

extension ChatSceneDIContainer: ChatFlowCoordinatorDependencies {
    // MARK: Repositories
    func makeUserRepository() -> UserRepository {
        return DefaultUserRepository()
    }
    
    func makeChatGroupsRepository() -> ChatGroupsRepository {
        return DefaultChatGroupsRepository()
    }
    
    // MARK: UseCases
    func makeLoadGroupsUseCase() -> LoadChatGroupsUseCase {
        return DefaultLoadChatGroupsUseCase(
            userRepository: makeUserRepository(),
            chatGroupsRepository: makeChatGroupsRepository()
        )
    }
    
    // MARK: Chat
    func makeChatViewController(actions: ChatViewModelActions) -> ChatViewController {
        return ChatViewController(chatViewModel: makeChatViewModel(actions: actions))
    }
    
    func makeChatViewModel(actions: ChatViewModelActions) -> ChatViewModel {
        return DefaultChatViewModel(loadChatGroupsUseCase: makeLoadGroupsUseCase(), actions: actions)
    }
    

    

    
    // MARK: Chat Content
    func makeChatContentViewController(group: Group) -> ChatContentViewController {
        return ChatContentViewController(group: group)
    }
}
