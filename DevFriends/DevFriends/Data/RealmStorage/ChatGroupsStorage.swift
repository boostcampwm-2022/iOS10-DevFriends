//
//  ChatGroupsStorage.swift
//  DevFriends
//
//  Created by 심주미 on 2022/11/26.
//

import RealmSwift

protocol ChatGroupsStorage {
    func fetch() -> [Group]
    func save(groups: [Group]) throws
}

final class DefaultChatGroupsStorage: ChatGroupsStorage, ContainsRealm {
    func fetch() -> [Group] {
        let groups = realm?.objects(AcceptedGroupResponseEntity.self)
        guard let groups = groups else { return [] }
        return groups.map{ $0.toDomain() }
    }
    
    func save(groups: [Group]) throws {
        try realm?.write {
            for group in groups {
                realm?.add(toGroupRealmResponse(group: group))
            }
        }
    }
    
    private func toGroupRealmResponse(group: Group) -> AcceptedGroupResponseEntity {
        let realmGroup = AcceptedGroupResponseEntity()
        realmGroup.id = group.id
        realmGroup.participantIDs.append(objectsIn: group.participantIDs)
        realmGroup.title = group.title
        realmGroup.chatID = group.chatID
        realmGroup.categories.append(objectsIn: group.categoryIDs)
        let location = LocationResponseDTO()
        location.latitude = group.location.latitude
        location.longitude = group.location.longitude
        realmGroup.location = location
        realmGroup.groupDescription = group.description
        realmGroup.time = group.time
        realmGroup.like = group.like
        realmGroup.hit = group.hit
        realmGroup.limitedNumberPeople = group.limitedNumberPeople
        realmGroup.managerID = group.managerID
        realmGroup.type = group.type
        return realmGroup
    }
}
