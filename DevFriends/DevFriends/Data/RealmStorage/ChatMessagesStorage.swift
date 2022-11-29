//
//  ChatMessagesStorage.swift
//  DevFriends
//
//  Created by 심주미 on 2022/11/29.
//

import Foundation

protocol ChatMessagesStorage {
    func fetch(groupID: String) -> [Message]
    func save(groupID: String, messages: [Message])
}

struct DefaultChatMessagesStorage: ChatMessagesStorage, ContainsRealm {
    func fetch(groupID: String) -> [Message] {
        let messages = realm?
            .objects(MessageResponseEntity.self)
            .filter("groupID == '\(groupID)'")
            .sorted(byKeyPath: "time")
        guard let messages = messages else { return [] }
        return messages.map{ $0.toDomain() }
    }
    
    func save(groupID: String, messages: [Message]) {
        do {
            try realm?.write {
                for message in messages {
                    realm?.add(toMessageResponseEntity(groupID: groupID, message: message))
                }
            }
        } catch {
            print(error)
        }
    }
    
    private func toMessageResponseEntity(groupID: String, message: Message) -> MessageResponseEntity {
        let realmMessage = MessageResponseEntity()
        realmMessage.groupID = groupID
        realmMessage.userNickname = message.userNickname
        realmMessage.userID = message.userID
        realmMessage.content = message.content
        realmMessage.time = message.time
        return realmMessage
    }
}
