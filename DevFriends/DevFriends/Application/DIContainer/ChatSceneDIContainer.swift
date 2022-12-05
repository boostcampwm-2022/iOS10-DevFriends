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
    func makeChatGroupsStorage() -> ChatGroupsStorage {
        return DefaultChatGroupsStorage()
    }
    
    func makeChatMessagesStorage() -> ChatMessagesStorage {
        return DefaultChatMessagesStorage()
    }
    
    // MARK: Repositories
    func makeUserRepository() -> UserRepository {
        return DefaultUserRepository()
    }
    
    func makeChatGroupsRepository() -> ChatGroupsRepository {
        return DefaultChatGroupsRepository(storage: makeChatGroupsStorage())
    }
    
    func makeChatMessagesRepository() -> ChatMessagesRepository {
        return DefaultChatMessagesRepository(storage: makeChatMessagesStorage())
    }
    
    // MARK: UseCases
    func makeLoadGroupsUseCase() -> LoadChatGroupsUseCase {
        return DefaultLoadChatGroupsUseCase(
            userRepository: makeUserRepository(),
            chatGroupsRepository: makeChatGroupsRepository()
        )
    }
    
    func makeSendChatMessageUseCase(chatUID: String, chatMessagesRepository: ChatMessagesRepository) -> SendChatMessagesUseCase {
        return DefaultSendChatMessagesUseCase(
            chatUID: chatUID,
            chatMessagesRepository: chatMessagesRepository
        )
    }
    
    func makeLoadChatMessagesUseCase(chatUID: String, chatMessagesRepository: ChatMessagesRepository) -> LoadChatMessagesUseCase {
        return DefaultLoadChatMessagesUseCase(
            chatUID: chatUID,
            chatMessagesRepository: chatMessagesRepository
        )
    }
    
    func makeRemoveMessageListenerUseCase(chatMessagesRepository: ChatMessagesRepository) -> RemoveMessageListenerUseCase {
        return DefaultRemoveMessageListenerUseCase(
            chatMessagesRepository: chatMessagesRepository
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
    func makeChatContentViewController(group: Group, actions: ChatContentViewModelActions) -> ChatContentViewController {
        return ChatContentViewController(
            chatContentViewModel: makeChatContentViewModel(group: group, actions: actions)
        )
    }
    
    func makeChatContentViewModel(group: Group, actions: ChatContentViewModelActions) -> ChatContentViewModel {
        let chatMessagesRepository = makeChatMessagesRepository()
        return DefaultChatContentViewModel(
            group: group,
            loadChatMessagesUseCase: makeLoadChatMessagesUseCase(chatUID: group.chatID, chatMessagesRepository: chatMessagesRepository),
            sendChatMessagesUseCase: makeSendChatMessageUseCase(chatUID: group.chatID, chatMessagesRepository: chatMessagesRepository),
            removeMessageListenerUseCase: makeRemoveMessageListenerUseCase(chatMessagesRepository: chatMessagesRepository),
            actions: actions
        )
    }
}
