//
//  DefaultGroupCommentRepository.swift
//  DevFriends
//
//  Created by 상현 on 2022/11/22.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

final class DefaultGroupCommentRepository: GroupCommentRepository {
    func fetch(_ groupId: String, limit: Int) async throws -> [Comment] {
        let querySnapshot = try await firestore
            .collection("Group")
            .document(groupId)
            .collection("Comment")
            .order(by: "time", descending: true)
            .limit(to: limit)
            .getDocuments()
        
        let comments = querySnapshot.documentChanges.compactMap { try? $0.document.data(as: CommentResponseDTO.self) }
        return comments.map { $0.toDomain() }
    }
    
    func post(_ comment: Comment, to groupId: String) -> String {
        do {
            let reference = try firestore
                .collection("Group")
                .document(groupId)
                .collection("Comment")
                .addDocument(from: makeCommentResponseDTO(comment: comment))
            
            return reference.documentID
        } catch {
            print(error)
        }
        
        return ""
    }
    
    private func makeCommentResponseDTO(comment: Comment) -> CommentResponseDTO {
        return CommentResponseDTO(
            content: comment.content,
            time: comment.time,
            userID: comment.userID
        )
    }
}
