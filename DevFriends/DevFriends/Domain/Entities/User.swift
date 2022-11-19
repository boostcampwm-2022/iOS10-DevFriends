//
//  User.swift
//  DevFriends
//
//  Created by 유승원 on 2022/11/18.
//

import Foundation
import FirebaseFirestoreSwift

struct User: Codable {
    @DocumentID var uid: String?
    let nickname: String
    let profileImagePath: String
    let categories: [String]
    let groups: [String]
}
