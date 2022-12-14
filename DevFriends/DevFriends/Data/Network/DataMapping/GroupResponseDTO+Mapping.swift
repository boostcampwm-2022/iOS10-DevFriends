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
    let time: Date
    let like: Int
    let hit: Int
    let limitedNumberPeople: Int
    let managerID: String
    let type: String
    let commentNumber: Int
}

extension GroupResponseDTO {
    func toDomain() -> Group {
        return Group(
            id: uid ?? "",
            participantIDs: participantIDs,
            title: title,
            chatID: chatID,
            categoryIDs: categories,
            location: Location(
                latitude: location.latitude,
                longitude: location.longitude
            ),
            description: description,
            time: time,
            like: like,
            hit: hit,
            limitedNumberPeople: limitedNumberPeople,
            managerID: managerID,
            type: type,
            commentNumber: commentNumber
        )
    }
}
