//
//  RemoveMessageListenerUseCase.swift
//  DevFriends
//
//  Created by 심주미 on 2022/12/05.
//

import Foundation

protocol RemoveMessageListenerUseCase {
    func execute()
}

final class DefaultRemoveMessageListenerUseCase: RemoveMessageListenerUseCase {
    private let chatMessagesRepository: ChatMessagesRepository
    
    init(chatMessagesRepository: ChatMessagesRepository) {
        self.chatMessagesRepository = chatMessagesRepository
    }
    
    func execute() {
        chatMessagesRepository.removeMessageListener()
    }
}
