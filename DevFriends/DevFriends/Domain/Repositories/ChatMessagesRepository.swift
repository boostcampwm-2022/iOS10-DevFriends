//
//  ChatMessagesRepository.swift
//  DevFriends
//
//  Created by 유승원 on 2022/11/19.
//

import Foundation
import FirebaseFirestore

protocol ChatMessagesRepository: ContainsFirestore {
    func fetchMessages(chatUID: String, completion: @escaping (_ messages: [Message]) -> Void) throws
    func sendMessage(chatUID: String, message: Message)
}

final class DefaultChatMessagesRepository {}

extension DefaultChatMessagesRepository: ChatMessagesRepository {
    func fetchMessages(chatUID: String, completion: @escaping (_ messages: [Message]) -> Void) throws {
        _ = Firestore
            .firestore()
            .collection("Chat")
            .document(chatUID)
            .collection("Message")
            .order(by: "time", descending: false)
            .addSnapshotListener { snapshot, error in
                guard let snapshot = snapshot, error == nil else { fatalError("message snapshot error occured!!") }
                
                let messages = snapshot.documentChanges.compactMap { try? $0.document.data(as: Message.self) }
                
                completion(messages)
            }
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
