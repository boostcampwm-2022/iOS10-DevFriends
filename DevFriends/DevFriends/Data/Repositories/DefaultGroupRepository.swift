//
//  DefaultGroupRepository.swift
//  DevFriends
//
//  Created by 심주미 on 2022/11/19.
//

import FirebaseFirestore
import Foundation
import CoreLocation

class DefaultGroupRepository: GroupRepository, ContainsFirestore {
    func fetch(groupType: GroupType?, location: Location?, distance: Double?) async throws -> [Group] {
        var groups: [Group] = []
        var query: Query
        if let location = location, let distance = distance {
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
            let group = try document.data(as: GroupResponseDTO.self).toDomain()
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
        return groups
    }
    
    func save(group: Group) {
        do {
            try firestore.collection("Group")
                .document()
                .setData(from: makeGroupResponseDTO(group: group))
        } catch {
            print(error)
        }
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