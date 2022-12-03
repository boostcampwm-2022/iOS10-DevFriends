//
//  ChatMessagesRepository.swift
//  DevFriends
//
//  Created by 유승원 on 2022/11/19.
//

protocol ChatMessagesRepository {
    func create(chatUID: String, message: Message)
    func fetch(chatUID: String, completion: @escaping (_ messages: [Message]) -> Void) throws
}
