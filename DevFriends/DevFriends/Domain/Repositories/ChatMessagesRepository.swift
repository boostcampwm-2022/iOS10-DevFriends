//
//  ChatMessagesRepository.swift
//  DevFriends
//
//  Created by 유승원 on 2022/11/19.
//

import Foundation

protocol ChatMessagesRepository: ContainsFirestore {
    func fetchMessages(chatUID: String, completion: @escaping (_ messages: [Message]) -> Void) throws
    func sendMessage(chatUID: String, message: Message)
}
