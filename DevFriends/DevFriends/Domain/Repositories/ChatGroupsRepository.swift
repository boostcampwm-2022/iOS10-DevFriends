//
//  ChatGroupsRepository.swift
//  DevFriends
//
//  Created by 유승원 on 2022/11/18.
//

import Foundation
import FirebaseFirestore

protocol ContainsFirestore {}

extension ContainsFirestore {
    var firestore: Firestore {
        return Firestore.firestore()
    }
}

protocol ChatGroupsRepository: ContainsFirestore {
    func fetchGroupList(uids: [String]) async throws -> [Group]
}

final class DefaultChatGroupsRepository {
    // MARK: 미래에 Realm을 쓸 때 사용할 의존성
    // let cache: ChatGroupsResponseStorage
}

extension DefaultChatGroupsRepository: ChatGroupsRepository {
    func fetchGroupList(uids: [String]) async throws -> [Group] {
        return try await withThrowingTaskGroup(of: Group.self) { taskGroup in
            for uid in uids {
                taskGroup.addTask {
                    try await self.fetchGroup(uid: uid)
                }
            }
            
            return try await taskGroup.reduce(into: []) { partialResult, group in
                partialResult.append(group)
            }
        }
    }
    
    private func fetchGroup(uid: String) async throws -> Group {
        let groupSnapshot = try await firestore.collection("Group").document(uid).getDocument()
        guard let group = groupSnapshot.data(),
            let participantIDs = group["participantIDs"] as? [String],
            let title = group["title"] as? String
        else { fatalError("Wrong UID!!") }
        
        return Group(participantIDs: participantIDs, title: title)
    }
}
