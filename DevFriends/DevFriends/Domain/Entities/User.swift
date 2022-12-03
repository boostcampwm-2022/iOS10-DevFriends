//
//  User.swift
//  DevFriends
//
//  Created by 유승원 on 2022/11/18.
//

import Foundation

struct User {
    let id: String
    let nickname: String
    let job: String
    let email: String
    let profileImagePath: String
    let categoryIDs: [String]
    var appliedGroupIDs: [String]
    var likeGroupIDs: [String]
}
