//
//  ChatResponseDTO+Mapping.swift
//  DevFriends
//
//  Created by 이대현 on 2022/11/30.
//

import Foundation
import FirebaseFirestoreSwift

struct ChatResponseDTO: Codable {
    @DocumentID var uid: String?
    let groupID: String
}

extension ChatResponseDTO {
    func toDomain() -> Chat {
        return Chat(id: uid ?? "", groupID: groupID)
    }
}
