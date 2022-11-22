//
//  DefaultGroupRepository.swift
//  DevFriends
//
//  Created by 상현 on 2022/11/22.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

final class DefaultGroupRepository: GroupRepository {
    func fetch(_ groupId: String) async throws -> Group {
        let snapshot = try await firestore.collection("Group").document(groupId).getDocument()
        
        return try snapshot.data(as: Group.self)
    }
}
