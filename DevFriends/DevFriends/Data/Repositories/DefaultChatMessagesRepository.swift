//
//  DefaultChatMessagesRepository.swift
//  DevFriends
//
//  Created by 유승원 on 2022/11/22.
//

import FirebaseFirestore

final class DefaultChatMessagesRepository: ContainsFirestore {
    let storage: ChatMessagesStorage
    var messageListener: ListenerRegistration?
    
    init(storage: ChatMessagesStorage) {
        self.storage = storage
    }
}

extension DefaultChatMessagesRepository: ChatMessagesRepository {
    func fetch(chatUID: String, completion: @escaping (_ messages: [Message]) -> Void) throws {
        let localMessages = storage.fetch(groupID: chatUID)
        var query: Query = firestore
            .collection(FirestorePath.chat.rawValue)
            .document(chatUID)
            .collection(FirestorePath.message.rawValue)
        
        let lastMessageTime = localMessages.last?.time
        if let lastMessageTime = lastMessageTime {
            query = query.whereField("time", isGreaterThan: lastMessageTime)
        }
        
        query = query.order(by: "time", descending: false)
        messageListener = query.addSnapshotListener { [weak self] snapshot, error in
            guard let snapshot = snapshot, error == nil else { fatalError("message snapshot error occured!!") }
            
            let messages = snapshot.documentChanges
                .compactMap { try? $0.document.data(as: MessageResponseDTO.self) }
                .filter { $0.time.firestamp() != lastMessageTime?.firestamp() }
                .map { $0.toDomain() }
            completion(messages)
            self?.storage.save(groupID: chatUID, messages: messages)
        }
        
        completion(localMessages)
    }
    
    func removeMessageListener() {
        messageListener?.remove()
    }
    
    func send(chatUID: String, message: Message) {
        do {
            let newDocReference = try firestore
                .collection(FirestorePath.chat.rawValue)
                .document(chatUID)
                .collection(FirestorePath.message.rawValue)
                .addDocument(from: makeMessageResponseDTO(message: message))
        } catch {
            print(error)
        }
    }
    
    func makeMessageResponseDTO(message: Message) -> MessageResponseDTO {
        return MessageResponseDTO(
            content: message.content,
            time: message.time,
            userID: message.userID,
            userNickname: message.userNickname
        )
    }
}
