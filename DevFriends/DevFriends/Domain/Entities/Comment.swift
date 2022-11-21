//
//  Comment.swift
//  DevFriends
//
//  Created by 상현 on 2022/11/21.
//

import Foundation
import FirebaseFirestoreSwift

struct Comment: Codable {
    @DocumentID var uid: String?
    let content: String
    let time: Date
    let userID: String
}
