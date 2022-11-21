//
//  GroupRepository.swift
//  DevFriends
//
//  Created by 상현 on 2022/11/21.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

protocol GroupRepository: ContainsFirestore {
    func fetch(_ groupId: String) async throws -> Group
}

final class DefaultGroupRepository: GroupRepository {
    func fetch(_ groupId: String) async throws -> Group {
        let snapshot = try await firestore.collection("Group").document(groupId).getDocument()
        
        return try snapshot.data(as: Group.self)
    }
}
