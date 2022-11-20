//
//  Group.swift
//  DevFriends
//
//  Created by 심주미 on 2022/11/14.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Group: Codable, Hashable {
    @DocumentID var uid: String? // TODO: 왜 옵셔널로 해야만 할까?
    let participantIDs: [String]
    let title: String
    let chatID: String
    let categories: [String]
    let location: GeoPoint
    let description: String
    let like: Int
    let limitedNumberPeople: Int
    let managerID: String
    let type: String
}
