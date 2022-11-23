//
//  GroupResponseDTO+Mapping.swift
//  DevFriends
//
//  Created by 심주미 on 2022/11/22.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct GroupResponseDTO: Codable {
    @DocumentID var uid: String?
    let participantIDs: [String]
    let title: String
    let chatID: String
    let categories: [String]
    let location: GeoPoint
    let description: String
    let like: Int
    let hit: Int
    let limitedNumberPeople: Int
    let managerID: String
    let type: String
}

extension GroupResponseDTO {
    func toDomain() -> Group {
        return Group(
            participantIDs: participantIDs,
            title: title,
            chatID: chatID,
            categories: categories,
            location: Location(latitude: location.latitude, longitude: location.longitude),
            description: description,
            like: like,
            hit: hit,
            limitedNumberPeople: limitedNumberPeople,
            managerID: managerID,
            type: type
        )
    }
}
