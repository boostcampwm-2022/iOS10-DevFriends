//
//  SaveChatGroupsUseCase.swift
//  DevFriends
//
//  Created by 이대현 on 2022/11/30.
//

import Foundation

protocol SaveChatUseCase {
    func execute(chat: Chat) -> String
}

final class DefaultSaveChatUseCase: SaveChatUseCase {
    private let chatRepository: ChatRepository
    
    init(chatRepository: ChatRepository) {
        self.chatRepository = chatRepository
    }
    
    func execute(chat: Chat) -> String {
        return self.chatRepository.save(chat: chat)
    }
}
