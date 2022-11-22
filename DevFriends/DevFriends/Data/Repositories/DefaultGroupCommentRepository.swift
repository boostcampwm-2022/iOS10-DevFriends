//
//  DefaultGroupCommentRepository.swift
//  DevFriends
//
//  Created by 상현 on 2022/11/22.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

final class DefaultGroupCommentRepository: GroupCommentRepository {
    func fetch(_ groupId: String) async throws -> [Comment] {
        let querySnapshot = try await firestore
            .collection("Group")
            .document(groupId)
            .collection("Comment")
            .order(by: "time")
            .getDocuments()
        
        let comments = querySnapshot.documentChanges.compactMap { try? $0.document.data(as: CommentResponseDTO.self) }
        return comments.map { $0.toDomain() }
    }
}
