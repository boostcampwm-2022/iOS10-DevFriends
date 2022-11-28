//
//  AcceptedGroupResponseEntity+Mapping.swift
//  DevFriends
//
//  Created by 심주미 on 2022/11/26.
//

import RealmSwift

class AcceptedGroupResponseEntity: Object {
    @objc dynamic var id: String = ""
    dynamic var participantIDs: List<String> = List<String>()
    @objc dynamic var title: String = ""
    @objc dynamic var chatID: String = ""
    dynamic var categories: List<String> = List<String>()
    @objc dynamic var location: LocationResponseDTO? = LocationResponseDTO()
    @objc dynamic var groupDescription: String = ""
    @objc dynamic var time: Date = .now
    @objc dynamic var like: Int = 0
    @objc dynamic var hit: Int = 0
    @objc dynamic var limitedNumberPeople: Int = 0
    @objc dynamic var managerID: String = ""
    @objc dynamic var type: String = ""
}

extension AcceptedGroupResponseEntity {
    func toDomain() -> Group {
        return Group(
            id: id,
            participantIDs: participantIDs.map{ $0 },
            title: title,
            chatID: chatID,
            categoryIDs: categories.map{ $0 },
            location: location?.toDomain() ?? Location(latitude: 0, longitude: 0),
            description: groupDescription,
            time: time,
            like: like,
            hit: hit,
            limitedNumberPeople: limitedNumberPeople,
            managerID: managerID,
            type: type
        )
    }
}

class LocationResponseDTO: Object {
    @objc dynamic var latitude: Double = 0.0
    @objc dynamic var longitude: Double = 0.0
}

extension LocationResponseDTO {
    func toDomain() -> Location {
        return Location(
            latitude: latitude,
            longitude: longitude
        )
    }
}
