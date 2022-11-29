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
    var profileImagePath: String
    let categoryIDs: [String]
    var appliedGroupIDs: [String]
}
