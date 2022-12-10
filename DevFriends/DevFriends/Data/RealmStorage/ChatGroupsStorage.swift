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
    func save(acceptedGroup: AcceptedGroup) throws
}

final class DefaultChatGroupsStorage: ChatGroupsStorage, ContainsRealm {
    func fetch() -> [AcceptedGroup] {
        let groups = realm
            .objects(AcceptedGroupResponseEntity.self)
            .sorted(byKeyPath: "acceptedTime", ascending: false)
        return groups.map { $0.toDomain() }
    }
    
    func save(acceptedGroups: [AcceptedGroup]) throws {
        // SW: 수정된 코드
        for group in acceptedGroups {
            try save(acceptedGroup: group)
        }
    }
    
    func save(acceptedGroup: AcceptedGroup) throws {
        try realm.write {
            realm.add(toAcceptedGroupResponseEntity(acceptedGroup: acceptedGroup), update: .modified)
        }
    }
    
    /// 특정 Group의 newMessageCount를 업데이트한다
    func update(groupID: String, newMessageCount: Int) {
        if let group = realm.object(ofType: AcceptedGroupResponseEntity.self, forPrimaryKey: groupID) {
            try! realm.write {
                group.lastMessageCount = newMessageCount
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
        realmGroup.lastMessageCount = acceptedGroup.newMessageCount
        realmGroup.lastMessageContent = acceptedGroup.lastMessageContent
        return realmGroup
    }
}
