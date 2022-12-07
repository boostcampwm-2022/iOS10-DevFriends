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
    
    func fetch(uid: String, completion: @escaping (_ user: User) -> Void) {
        _ = firestore
            .collection(FirestorePath.user.rawValue)
            .document(uid)
            .addSnapshotListener { snapshot, error in
                guard let snapshot = snapshot, error == nil else { fatalError("user snapshot error occured!!") }
                
                do {
                    let user = try snapshot.data(as: UserResponseDTO.self)
                    completion(user.toDomain())
                } catch {
                    fatalError("\(error)")
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
    
    func isExist(uid: String) async throws -> Bool {
        let document = try await firestore.collection(FirestorePath.user.rawValue).document(uid).getDocument()
        
        if document.exists {
            return true
        }
        
        return false
    }
    
    func create(uid: String?, user: User, completion: @escaping (Error?) -> Void) throws {
        let userResponseDTO = makeUserResponseDTO(user: user)
        if let uid = uid {
            try firestore
                .collection(FirestorePath.user.rawValue)
                .document(uid)
                .setData(from: userResponseDTO) { error in
                    completion(error)
                }
        } else {
            _ = try firestore
                .collection(FirestorePath.user.rawValue)
                .addDocument(from: userResponseDTO) { error in
                    completion(error)
                }
        }
    }
}

extension DefaultUserRepository {
    func createUserGroup(userID: String, groupID: String) {
        let userGroupResponseDTO = UserGroupResponseDTO(groupID: groupID, time: Date.now)
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
}

// MARK: Private
extension DefaultUserRepository {
    private func makeUserResponseDTO(user: User) -> UserResponseDTO {
        return UserResponseDTO(
            nickname: user.nickname,
            job: user.job,
            email: user.email,
            profileImagePath: user.profileImagePath,
            categories: user.categoryIDs,
            appliedGroups: user.appliedGroupIDs,
            likeGroups: user.likeGroupIDs
        )
    }
}
