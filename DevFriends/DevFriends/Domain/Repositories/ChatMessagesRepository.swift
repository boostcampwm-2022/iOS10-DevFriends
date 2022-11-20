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
    func sendMessage(chatUID: String, message: Message)
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
    
    func sendMessage(chatUID: String, message: Message) {
        do {
            let newDocReference = try firestore
                .collection("Chat")
                .document(chatUID)
                .collection("Message")
                .addDocument(from: message)
            print("message stored with new document reference: \(newDocReference)")
        } catch {
            print(error)
        }
    }
}
