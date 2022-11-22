//
//  Group.swift
//  DevFriends
//
//  Created by 심주미 on 2022/11/14.
//

import Foundation

struct Group: Hashable {
    let participantIDs: [String]
    let title: String
    let chatID: String
    let categories: [String]
    let location: Location
    let description: String
    let like: Int
    let limitedNumberPeople: Int
    let managerID: String
    let type: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(chatID)
    }
}
