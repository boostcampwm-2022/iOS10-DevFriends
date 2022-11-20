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

// TODO: LoadChatMessagesUseCase랑 들고 있는 의존성이 완전히 똑같은데 합치는게 나으려나.. 토의 고고
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
