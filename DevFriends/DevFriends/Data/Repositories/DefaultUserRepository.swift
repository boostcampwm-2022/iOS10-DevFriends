//
//  DefaultUserRepository.swift
//  DevFriends
//
//  Created by 유승원 on 2022/11/22.
//

import FirebaseFirestore

final class DefaultUserRepository: ContainsFirestore {}

extension DefaultUserRepository: UserRepository {
    func fetch(uid: String) async throws -> User {
        let userSnapshot = try await firestore.collection(FirestorePath.user.rawValue).document(uid).getDocument()
        let user = try userSnapshot.data(as: UserResponseDTO.self)
        return user.toDomain()
    }
        
    func fetch(uids: [String]) async throws -> [User] {
        return try await withThrowingTaskGroup(of: User.self) { taskGroup in
            uids.forEach { id in
                if id.isEmpty { return }
                
                taskGroup.addTask {
                    try await self.fetch(uid: id)
                }
            }
            
            return try await taskGroup.reduce(into: []) { partialResult, user in
                partialResult.append(user)
            }
        }
    }
    
    func update(userID: String, user: User) {
        do {
            let userResponseDTO = makeUserResponseDTO(user: user)
            try firestore.collection(FirestorePath.user.rawValue).document(userID).setData(from: userResponseDTO)
        } catch {
            print(error)
        }
    }
    
    func update(_ user: User) {
        do {
            try firestore
                .collection(FirestorePath.user.rawValue)
                .document(user.id)
                .setData(from: makeUserResponseDTO(user: user))
        } catch {
            print(error)
        }
    }
    
    func createUserGroup(userID: String, groupID: String) {
        let userGroup = UserGroup(groupID: groupID, time: Date())
        let userGroupResponseDTO = makeUserGroupResponseDTO(userGroup: userGroup)
        
        do {
            _ = try firestore
                .collection(FirestorePath.user.rawValue)
                .document(userID)
                .collection(FirestorePath.group.rawValue)
                .addDocument(from: userGroupResponseDTO)
        } catch {
            print(error)
        }
    }
    
    func fetchUserGroup(of uid: String) async throws -> [UserGroup] {
        let snapshot = try await firestore
            .collection(FirestorePath.user.rawValue)
            .document(uid)
            .collection(FirestorePath.group.rawValue)
            .getDocuments()
        let groups = try snapshot.documents
            .map { try $0.data(as: UserGroupResponseDTO.self) }
            .map { $0.toDomain() }
        
        return groups
    }
}

// MARK: Private
extension DefaultUserRepository {
    private func makeUserResponseDTO(user: User) -> UserResponseDTO {
        return UserResponseDTO(
            nickname: user.nickname,
            job: user.job,
            profileImagePath: user.profileImagePath,
            categories: user.categoryIDs,
            appliedGroups: user.appliedGroupIDs,
            likeGroups: user.likeGroupIDs
        )
    }
    
    private func makeUserGroupResponseDTO(userGroup: UserGroup) -> UserGroupResponseDTO {
        return UserGroupResponseDTO(groupID: userGroup.groupID, time: userGroup.time)
    }
}
