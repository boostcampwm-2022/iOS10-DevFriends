//
//  ChatRepository.swift
//  DevFriends
//
//  Created by 이대현 on 2022/11/30.
//

import Foundation

protocol ChatRepository {
    func save(chat: Chat) -> String
}
