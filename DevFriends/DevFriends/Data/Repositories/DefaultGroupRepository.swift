//
//  DefaultGroupRepository.swift
//  DevFriends
//
//  Created by 심주미 on 2022/11/19.
//

import CoreLocation
import FirebaseFirestore

final class DefaultGroupRepository: GroupRepository {
    func create(group: Group) -> String {
        do {
            let reference = firestore.collection(FirestorePath.group.rawValue)
                .document()
            try reference.setData(from: makeGroupResponseDTO(group: group))
            return reference.documentID
        } catch {
            print(error)
            return ""
        }
    }
    
    func fetch(groupID: String) async throws -> Group {
        let group = try await firestore
            .collection(FirestorePath.group.rawValue)
            .document(groupID)
            .getDocument()
            .data(as: GroupResponseDTO.self)
        
        return group.toDomain()
    }
    
    func fetch(groupIDs: [String]) async throws -> [Group] {
        return try await withThrowingTaskGroup(of: Group.self) { taskGroup in
            groupIDs.forEach { id in
                if id.isEmpty { return }
                
                taskGroup.addTask {
                    try await self.fetch(groupID: id)
                }
            }
            
            return try await taskGroup.reduce(into: []) { partialResult, user in
                partialResult.append(user)
            }
        }
    }
    
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
            
            query = firestore
                .collection(FirestorePath.group.rawValue)
                .whereField("location", isGreaterThan: lesserGeopoint)
                .whereField("location", isLessThan: greaterGeopoint)
            if let groupType = groupType {
                query = query.whereField("type", isEqualTo: groupType.rawValue)
            }
        } else {
            if let groupType = groupType {
                query = firestore.collection(FirestorePath.group.rawValue)
                    .whereField("type", isEqualTo: groupType.rawValue)
            } else {
                query = firestore.collection(FirestorePath.group.rawValue)
            }
        }
        
        try await query.getDocuments().documents.forEach {
            let group = try $0.data(as: GroupResponseDTO.self).toDomain()
            if let location = location, location == group.location {
                groups.insert(group, at: 0)
            } else {
                groups.append(group)
            }
        }
        
        return groups
    }
    
    // Refactor: wherefield로 카테고리 필터링
    func fetch(filter: Filter) async throws -> [Group] {
        var groups: [Group] = []
        let snapshot: QuerySnapshot
        if let groupFilter = filter.groupFilter {
            snapshot = try await firestore.collection(FirestorePath.group.rawValue)
                .whereField("type", isEqualTo: groupFilter.rawValue)
            /*.whereField()*/
                .getDocuments()
        } else {
            snapshot = try await firestore.collection(FirestorePath.group.rawValue)
                .getDocuments()
        }
        
        for document in snapshot.documents {
            let group = try document.data(as: GroupResponseDTO.self).toDomain()
            // 필터 카테고리가 비어있으면 필터링 x
            // 필터 카테고리 중 하나라도 모임 카테고리가 겹쳐야 함
            if filter.categoryFilter.isEmpty ||
                !group.categoryIDs.filter({ filter.categoryFilter.contains($0) }).isEmpty {
                groups.append(group)
            }
        }
        return groups
    }
    
    func update(groupID: String, group: Group) {
        do {
            let groupResponseDTO = makeGroupResponseDTO(group: group)
            try firestore.collection(FirestorePath.group.rawValue).document(groupID).setData(from: groupResponseDTO)
        } catch {
            print(error)
        }
    }
}

// MARK: Private
extension DefaultGroupRepository {
    private func makeGroupResponseDTO(group: Group) -> GroupResponseDTO {
        return GroupResponseDTO(
            participantIDs: group.participantIDs,
            title: group.title,
            chatID: group.chatID,
            categories: group.categoryIDs,
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
