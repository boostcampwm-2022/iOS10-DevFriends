//
//  DefaultGroupRepository.swift
//  DevFriends
//
//  Created by 심주미 on 2022/11/19.
//

import FirebaseFirestore
import Foundation
import CoreLocation

class DefaultGroupRepository: GroupRepository {
    let firestore = Firestore.firestore()
    
    func fetch(groupType: GroupType?, location: (latitude: Double, longitude: Double)?) async throws -> [Group] {
        var groups: [Group] = []
        let snapshot: QuerySnapshot
        if let groupType = groupType {
            snapshot = try await firestore.collection("Group")
                .whereField("type", isEqualTo: groupType.rawValue)
                .getDocuments()
        } else {
            snapshot = try await firestore.collection("Group")
                .getDocuments()
        }
        
        for document in snapshot.documents {
            let groupData = document.data()
            if let group = makeGroup(group: groupData) {
                if let location = location {
                    let from = CLLocation(latitude: location.latitude, longitude: location.longitude)
                    let to = CLLocation(latitude: group.location.latitude, longitude: group.location.longitude)
                    if location == group.location {
                        groups.insert(group, at: 0)
                    } else {
                        if to.distance(from: from) < 1000 {
                            groups.append(group)
                        }
                    }
                } else {
                    groups.append(group)
                }
            }
        }
        return groups
    }
    
    // Refactor: wherefield로 카테고리 필터링
    func fetch(filter: Filter) async throws -> [Group] {
        var groups: [Group] = []
        let snapshot: QuerySnapshot
        if let groupFilter = filter.groupFilter {
            snapshot = try await firestore.collection("Group")
                .whereField("type", isEqualTo: groupFilter.rawValue)
                /*.whereField(<#T##field: String##String#>, in: <#T##[Any]#>)*/
                .getDocuments()
        } else {
            snapshot = try await firestore.collection("Group")
                .getDocuments()
        }
        
        for document in snapshot.documents {
            let groupData = document.data()
            if let group = makeGroup(group: groupData) {
                // 필터 카테고리가 비어있으면 필터링 x
                // 필터 카테고리 중 하나라도 모임 카테고리가 겹쳐야 함
                if filter.categoryFilter.isEmpty ||
                   !group.categories.filter({ filter.categoryFilter.contains($0) }).isEmpty {
                    groups.append(group)
                }
            }
        }
        return groups
    }
    
    func makeGroup(group: [String : Any]) -> Group? {
        guard let title = group["title"] as? String,
              let description = group["description"] as? String,
              let participantIDs = group["participantIDs"] as? [String],
              let categories = group["categories"] as? [String],
              let chatID = group["chatID"] as? String,
              let like = group["like"] as? Int,
              let limitedNumberPeople = group["limitedNumberPeople"] as? Int,
              let location = group["location"] as? GeoPoint,
              let managerID = group["managerID"] as? String,
              let type = group["type"] as? String,
              let groupType = GroupType(rawValue: type)
        else { return nil }
        return Group(participantIDs: participantIDs,
                     title: title,
                     categories: categories,
                     chatID: chatID,
                     description: description,
                     like: like,
                     limitedNumberPeople: limitedNumberPeople,
                     location: (location.latitude, location.longitude),
                     managerID: managerID,
                     type: groupType)
    }
    
    func save(group: Group) {
        firestore.collection("Group").document()
            .setData(makeDic(group: group))
    }
    
    func makeDic(group: Group) -> [String : Any] {
        var result: [String :  Any] = [:]
        result["chatID"] = group.chatID
        result["location"] = GeoPoint(latitude: group.location.latitude, longitude: group.location.longitude)
        result["managerID"] = group.managerID
        result["limitedNumberPeople"] = group.limitedNumberPeople
        result["title"] = group.title
        result["type"] = group.type.rawValue
        result["categories"] = group.categories
        result["participantIDs"] = group.participantIDs
        result["description"] = group.description
        result["like"] = group.like
        return result
    }
    func makeGroupResponseDTO(group: Group) -> GroupResponseDTO {
        return GroupResponseDTO(
            participantIDs: group.participantIDs,
            title: group.title,
            chatID: group.chatID,
            categories: group.categories,
            location: GeoPoint(latitude: group.location.latitude, longitude: group.location.longitude),
            description: group.description,
            time: group.time,
            like: group.like,
            hit: group.hit,
            limitedNumberPeople: group.limitedNumberPeople,
            managerID: group.managerID,
            type: group.type
        )
    }
}
