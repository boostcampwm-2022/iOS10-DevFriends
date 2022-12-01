//
//  DefaultChatRepository.swift
//  DevFriends
//
//  Created by 이대현 on 2022/11/30.
//

import Foundation
import FirebaseFirestoreSwift

final class DefaultChatRepository: ContainsFirestore {}

extension DefaultChatRepository: ChatRepository {
    func save(chat: Chat) -> String {
        do {
            let reference = try firestore
                .collection("Chat")
                .addDocument(from: makeChatResponseDTO(chat: chat))
            return reference.documentID
        } catch {
            print(error)
            return ""
        }
    }
    
    private func makeChatResponseDTO(chat: Chat) -> ChatResponseDTO {
        return ChatResponseDTO(groupID: chat.groupID)
    }
}
