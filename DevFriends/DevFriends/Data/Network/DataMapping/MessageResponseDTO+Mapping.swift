//
//  MessageResponseDTO+Mapping.swift
//  DevFriends
//
//  Created by 심주미 on 2022/11/22.
//

import Foundation
import FirebaseFirestoreSwift

struct MessageResponseDTO: Codable {
    @DocumentID var uid: String?
    let content: String
    let time: Date
    let userID: String
    let userNickname: String
}

extension MessageResponseDTO {
    func toDomain() -> Message {
        return Message(content: content,
                       time: time,
                       userID: userID,
                       userNickname: userNickname)
    }
}
