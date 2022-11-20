//
//  SendChatMessagesUseCase.swift
//  DevFriends
//
//  Created by 유승원 on 2022/11/20.
//

import Foundation

protocol SendChatMessagesUseCase {
    func send(message: Message)
}

final class DefaultSendChatMessagesUseCase: SendChatMessagesUseCase {
    private let chatUID: String
    private let chatMessagesRepository: ChatMessagesRepository
    
    init(chatUID: String, chatMessagesRepository: ChatMessagesRepository) {
        self.chatUID = chatUID
        self.chatMessagesRepository = chatMessagesRepository
    }
    
    func send(message: Message) {
        self.chatMessagesRepository.sendMessage(chatUID: self.chatUID, message: message)
    }
}
