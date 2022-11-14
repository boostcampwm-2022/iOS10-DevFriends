//
//  Group.swift
//  DevFriends
//
//  Created by 심주미 on 2022/11/14.
//

import Foundation

struct Group: Hashable {
    let categories: [String]
    let chatID: String
    let currentNumberPeople: Int
    let description: String
    let like: Int
    let limitedNumberPeople: Int
    let managerID: String
    let participantIDs: [String]
    let title: String
    let type: String
}
