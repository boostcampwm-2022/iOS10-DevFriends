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
    
    func fetch(groupType: GroupType?, location: (latitude: Double, longitude: Double)?, distance: Double?) async throws -> [Group] {
        var groups: [Group] = []
        var query: Query
        if let location = location, var distance = distance {
            distance = min(1100000, distance)
            let lat = 0.000009094341036
            let lon = 0.00001126887537
            
            let lowerLat = location.latitude - (lat * distance)
            let lowerLon = location.longitude - (lon * distance)
            
            let greaterLat = location.latitude + (lat * distance)
            let greaterLon = location.longitude + (lon * distance)
            
            let lesserGeopoint = GeoPoint(latitude: lowerLat, longitude: lowerLon)
            let greaterGeopoint = GeoPoint(latitude: greaterLat, longitude: greaterLon)
            query = firestore.collection("Group")
                .whereField("location", isGreaterThan: lesserGeopoint)
                .whereField("location", isLessThan: greaterGeopoint)
            if let groupType = groupType {
                query = query.whereField("type", isEqualTo: groupType.rawValue)
            }
        } else {
            if let groupType = groupType {
                query = firestore.collection("Group")
                    .whereField("type", isEqualTo: groupType.rawValue)
            } else {
                query = firestore.collection("Group")
            }
        }
        let snapshot = try await query.getDocuments()
        
        for document in snapshot.documents {
            let groupData = document.data()
            if let group = makeGroup(group: groupData) {
                if let location = location {
                    if location == group.location {
                        groups.insert(group, at: 0)
                    } else {
                        groups.append(group)
                    }
                } else {
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
}
