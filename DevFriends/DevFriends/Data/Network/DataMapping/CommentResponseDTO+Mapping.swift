//
//  CommentResponseDTO+Mapping.swift
//  DevFriends
//
//  Created by 상현 on 2022/11/22.
//

import Foundation
import FirebaseFirestoreSwift

struct CommentResponseDTO: Codable {
    @DocumentID var uid: String?
    let content: String
    let time: Date
    let userID: String
}

extension CommentResponseDTO {
    func toDomain() -> Comment {
        return Comment(
            id: uid,
            content: content,
            time: time,
            userID: userID
        )
    }
}
