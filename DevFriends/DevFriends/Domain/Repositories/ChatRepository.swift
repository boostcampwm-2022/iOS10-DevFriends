//
//  ChatRepository.swift
//  DevFriends
//
//  Created by 이대현 on 2022/11/30.
//

protocol ChatRepository {
    func create(chat: Chat) -> String
}
