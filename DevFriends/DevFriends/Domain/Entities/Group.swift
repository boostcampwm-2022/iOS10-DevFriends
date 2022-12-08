//
//  Group.swift
//  DevFriends
//
//  Created by 심주미 on 2022/11/14.
//

import Foundation

struct Group: Hashable {
    let id: String
    var participantIDs: [String]
    let title: String
    let chatID: String
    let categoryIDs: [String]
    let location: Location
    let description: String
    let time: Date
    var like: Int
    let hit: Int
    let limitedNumberPeople: Int
    let managerID: String
    let type: String
    var commentNumber: Int
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(chatID)
    }
}
