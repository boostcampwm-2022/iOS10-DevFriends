//
//  DefaultChatRepository.swift
//  DevFriends
//
//  Created by 이대현 on 2022/11/30.
//

import FirebaseFirestoreSwift

final class DefaultChatRepository: ContainsFirestore {}

extension DefaultChatRepository: ChatRepository {
    func create(chat: Chat) -> String {
        do {
            let reference = try firestore
                .collection(FirestorePath.chat.rawValue)
                .addDocument(from: makeChatResponseDTO(chat: chat))
            return reference.documentID
        } catch {
            print(error)
            return ""
        }
    }
}

// MARK: Private
extension DefaultChatRepository {
    private func makeChatResponseDTO(chat: Chat) -> ChatResponseDTO {
        return ChatResponseDTO(groupID: chat.groupID)
    }
}
