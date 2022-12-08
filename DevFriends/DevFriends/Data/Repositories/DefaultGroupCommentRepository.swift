//
//  DefaultGroupCommentRepository.swift
//  DevFriends
//
//  Created by 상현 on 2022/11/22.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

final class DefaultGroupCommentRepository: ContainsFirestore {}

extension DefaultGroupCommentRepository: GroupCommentRepository {
    func create(_ comment: Comment, to groupId: String) -> String {
        do {
            let reference = try firestore
                .collection(FirestorePath.group.rawValue)
                .document(groupId)
                .collection(FirestorePath.comment.rawValue)
                .addDocument(from: makeCommentResponseDTO(comment: comment))
            
            return reference.documentID
        } catch {
            print(error)
        }
        
        return ""
    }
    
    func fetch(_ groupId: String, from: Date?, limit: Int) async throws -> [Comment] {
        var reference = firestore
            .collection(FirestorePath.group.rawValue)
            .document(groupId)
            .collection(FirestorePath.comment.rawValue)
        
        var querySnapshot: QuerySnapshot
        if let from = from {
            querySnapshot = try await reference
                .whereField("time", isLessThan: from)
                .order(by: "time", descending: true)
                .limit(to: limit)
                .getDocuments()
        } else {
            querySnapshot = try await reference
                .order(by: "time", descending: true)
                .limit(to: limit)
                .getDocuments()
        }
        
        let comments = querySnapshot.documentChanges.compactMap { try? $0.document.data(as: CommentResponseDTO.self) }
            .filter { $0.time != from }
        return comments.map { $0.toDomain() }
    }
}

// MARK: Private
extension DefaultGroupCommentRepository {
    private func makeCommentResponseDTO(comment: Comment) -> CommentResponseDTO {
        return CommentResponseDTO(
            content: comment.content,
            time: comment.time,
            userID: comment.userID
        )
    }
}
