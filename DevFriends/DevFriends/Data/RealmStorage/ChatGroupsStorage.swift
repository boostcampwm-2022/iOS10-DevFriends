//
//  ChatGroupsStorage.swift
//  DevFriends
//
//  Created by 심주미 on 2022/11/26.
//

import RealmSwift

protocol ChatGroupsStorage {
    func fetch() -> [AcceptedGroup]
    func save(acceptedGroups: [AcceptedGroup]) throws
}

final class DefaultChatGroupsStorage: ChatGroupsStorage, ContainsRealm {
    func fetch() -> [AcceptedGroup] {
        let groups = realm?
            .objects(AcceptedGroupResponseEntity.self)
            .sorted(byKeyPath: "acceptedTime", ascending: false)
        guard let groups = groups else { return [] }
        return groups.map{ $0.toDomain() }
    }
    
    func save(acceptedGroups: [AcceptedGroup]) throws {
        try realm?.write {
            for group in acceptedGroups {
                realm?.add(toAcceptedGroupResponseEntity(acceptedGroup: group), update: .modified)
            }
        }
    }
    
    private func toAcceptedGroupResponseEntity(acceptedGroup: AcceptedGroup) -> AcceptedGroupResponseEntity {
        let group = acceptedGroup.group
        let realmGroup = AcceptedGroupResponseEntity()
        realmGroup.id = group.id
        realmGroup.participantIDs.append(objectsIn: group.participantIDs)
        realmGroup.title = group.title
        realmGroup.chatID = group.chatID
        realmGroup.categories.append(objectsIn: group.categoryIDs)
        let location = LocationResponseEntity()
        location.latitude = group.location.latitude
        location.longitude = group.location.longitude
        realmGroup.location = location
        realmGroup.groupDescription = group.description
        realmGroup.postTime = group.time
        realmGroup.like = group.like
        realmGroup.hit = group.hit
        realmGroup.limitedNumberPeople = group.limitedNumberPeople
        realmGroup.managerID = group.managerID
        realmGroup.type = group.type
        realmGroup.acceptedTime = acceptedGroup.time
        return realmGroup
    }
}
