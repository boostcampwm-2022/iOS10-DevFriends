//
//  ChatMessagesRepository.swift
//  DevFriends
//
//  Created by 유승원 on 2022/11/19.
//

import Foundation
import FirebaseFirestore

protocol ChatMessagesRepository: ContainsFirestore {
    func fetchMessages(chatUID: String) async throws -> [Message]
}

final class DefaultChatMessagesRepository {}

extension DefaultChatMessagesRepository: ChatMessagesRepository {
    func fetchMessages(chatUID: String) async throws -> [Message] {
        let messageSnapshots = try await firestore
            .collection("Chat")
            .document(chatUID)
            .collection("Message")
            .getDocuments().documents
        
        print(messageSnapshots[0].data())
        
        return messageSnapshots
            .compactMap { try? $0.data(as: Message.self) }
            .reduce(into: []) { $0.append($1) }
    }
}
