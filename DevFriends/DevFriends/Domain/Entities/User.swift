//
//  User.swift
//  DevFriends
//
//  Created by 유승원 on 2022/11/18.
//

import Foundation

struct User {
    let id: String
    var nickname: String
    var job: String
    let email: String
    var profileImagePath: String
    var categoryIDs: [String]
    var appliedGroupIDs: [String]
    var likeGroupIDs: [String]
}
