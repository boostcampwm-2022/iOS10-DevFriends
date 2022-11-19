//
//  LoadChatMessagesUseCase.swift
//  DevFriends
//
//  Created by 유승원 on 2022/11/19.
//

import Foundation

protocol LoadChatMessagesUseCase {
    func load() async throws -> [Message]
}

final class DefaultLoadChatMessagesUseCase: LoadChatMessagesUseCase {
    private let chatUID: String
    private let chatMessagesRepository: ChatMessagesRepository
    
    init(chatUID: String, chatMessagesRepository: ChatMessagesRepository) {
        self.chatUID = chatUID
        self.chatMessagesRepository = chatMessagesRepository
    }
    
    func load() async throws -> [Message] {
        return try await self.chatMessagesRepository.fetchMessages(chatUID: self.chatUID)
    }
}
