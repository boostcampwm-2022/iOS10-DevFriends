//
//  User.swift
//  DevFriends
//
//  Created by 유승원 on 2022/11/18.
//

import Foundation
import FirebaseFirestoreSwift

struct User: Codable {
    let id: String
    let nickname: String
    let job: String
    let profileImagePath: String
    let categoryIDs: [String]
    let groupIDs: [String]
    let appliedGroupIDs: [String]
}
