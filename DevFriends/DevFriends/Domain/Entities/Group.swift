//
//  Group.swift
//  DevFriends
//
//  Created by 심주미 on 2022/11/14.
//

import Foundation

struct Group: Hashable {
    let id: String
    let participantIDs: [String]
    let title: String
    let categories: [String]
    let chatID: String
    let description: String
    let time: Date
    let like: Int
    let hit: Int
    let limitedNumberPeople: Int
    let location: (latitude: Double, longitude: Double)
    let managerID: String
    let type: GroupType
    
    static func == (lhs: Group, rhs: Group) -> Bool {
        return lhs.chatID == rhs.chatID
    }
    
    func hash(into hasher: inout Hasher) {
        return hasher.combine(chatID)
    }
}
