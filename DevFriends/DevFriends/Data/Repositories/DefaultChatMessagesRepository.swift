//
//  DefaultChatMessagesRepository.swift
//  DevFriends
//
//  Created by 유승원 on 2022/11/22.
//

import Foundation
import FirebaseFirestore

final class DefaultChatMessagesRepository {}

extension DefaultChatMessagesRepository: ChatMessagesRepository {
    func fetch(chatUID: String, completion: @escaping (_ messages: [Message]) -> Void) throws {
        _ = firestore
            .collection("Chat")
            .document(chatUID)
            .collection("Message")
            .order(by: "time", descending: false)
            .addSnapshotListener { snapshot, error in
                guard let snapshot = snapshot, error == nil else { fatalError("message snapshot error occured!!") }
                
                let messages = snapshot.documentChanges.compactMap {
                    try? $0.document.data(as: MessageResponseDTO.self)
                    
                }
                
                completion(messages.map{$0.toDomain()})
            }
    }
    
    func send(chatUID: String, message: Message) {
        do {
            let newDocReference = try firestore
                .collection("Chat")
                .document(chatUID)
                .collection("Message")
                .addDocument(from: makeMessageResponseDTO(message: message))
            print("message stored with new document reference: \(newDocReference)")
        } catch {
            print(error)
        }
    }
    
    func makeMessageResponseDTO(message: Message) -> MessageResponseDTO {
        return MessageResponseDTO(content: message.content,
                                  time: message.time,
                                  userID: message.userID,
                                  userNickname: message.userNickname)
    }
}
