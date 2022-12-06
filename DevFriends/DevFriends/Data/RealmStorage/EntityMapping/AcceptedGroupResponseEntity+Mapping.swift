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
    @objc dynamic var location: LocationResponseEntity? = LocationResponseEntity()
    @objc dynamic var groupDescription: String = ""
    @objc dynamic var postTime: Date = .now
    @objc dynamic var like: Int = 0
    @objc dynamic var hit: Int = 0
    @objc dynamic var limitedNumberPeople: Int = 0
    @objc dynamic var managerID: String = ""
    @objc dynamic var type: String = ""
    @objc dynamic var acceptedTime: Date = .now
    @objc dynamic var lastMessageContent: String = ""
    @objc dynamic var lastMessageCount: Int = 0
}

extension AcceptedGroupResponseEntity {
    func toDomain() -> AcceptedGroup {
        let group = Group(
            id: id,
            participantIDs: participantIDs.map{ $0 },
            title: title,
            chatID: chatID,
            categoryIDs: categories.map{ $0 },
            location: location?.toDomain() ?? Location(latitude: 0, longitude: 0),
            description: groupDescription,
            time: postTime,
            like: like,
            hit: hit,
            limitedNumberPeople: limitedNumberPeople,
            managerID: managerID,
            type: type
        )
        
        return AcceptedGroup(
            group: group,
            time: acceptedTime,
            lastMessageContent: lastMessageContent,
            newMessageCount: lastMessageCount
        )
    }
}

class LocationResponseEntity: Object {
    @objc dynamic var latitude: Double = 0.0
    @objc dynamic var longitude: Double = 0.0
}

extension LocationResponseEntity {
    func toDomain() -> Location {
        return Location(
            latitude: latitude,
            longitude: longitude
        )
    }
}
