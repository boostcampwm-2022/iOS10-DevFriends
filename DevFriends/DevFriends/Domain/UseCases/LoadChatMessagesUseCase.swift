//
//  LoadChatMessagesUseCase.swift
//  DevFriends
//
//  Created by 유승원 on 2022/11/19.
//

import Foundation

protocol LoadChatMessagesUseCase {
    func execute(completion: @escaping (_ messages: [Message]) -> Void) throws
}

final class DefaultLoadChatMessagesUseCase: LoadChatMessagesUseCase {
    private let chatUID: String
    private let chatMessagesRepository: ChatMessagesRepository
    
    init(chatUID: String, chatMessagesRepository: ChatMessagesRepository) {
        self.chatUID = chatUID
        self.chatMessagesRepository = chatMessagesRepository
    }
    
    func execute(completion: @escaping (_ messages: [Message]) -> Void) throws {
        try self.chatMessagesRepository.fetch(chatUID: self.chatUID, completion: completion)
    }
}
