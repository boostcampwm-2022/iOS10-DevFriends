//
//  CommentRepository.swift
//  DevFriends
//
//  Created by 상현 on 2022/11/21.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

protocol CommentRepository: ContainsFirestore {
    func fetchComments(groupId: String) async throws -> [Comment]
}

final class DefaultCommentRepository: CommentRepository {
    func fetchComments(groupId: String) async throws -> [Comment] {
        let querySnapshot = try await firestore
            .collection("Group")
            .document(groupId)
            .collection("Comment")
            .getDocuments()
        
        let comments = querySnapshot.documentChanges.compactMap{ try? $0.document.data(as: Comment.self) }
        return comments
    }
}
