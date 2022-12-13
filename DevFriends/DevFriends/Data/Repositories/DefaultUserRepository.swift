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
    
    func fetch(uid: String, completion: @escaping (_ user: User) -> Void) -> ListenerRegistration {
        return firestore
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
    
    func delete(id: String) {
        let snapshot = firestore.collection(FirestorePath.user.rawValue).document(id)
        
        snapshot.collection(FirestorePath.group.rawValue).getDocuments { snapshot, error in
            if let error = error {
                print(error)
            } else {
                snapshot?.documents.forEach({ snapshot in
                    snapshot.reference.delete()
                })
            }
        }
        
        snapshot.collection(FirestorePath.notification.rawValue).getDocuments { snapshot, error in
            if let error = error {
                print(error)
            } else {
                snapshot?.documents.forEach({ snapshot in
                    snapshot.reference.delete()
                })
            }
        }
        snapshot.delete()
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
    
    func fetchUserGroup(uid: String, completion: @escaping (_ userGroups: [UserGroup]) -> Void) {
        _ = firestore
            .collection(FirestorePath.user.rawValue)
            .document(uid)
            .collection(FirestorePath.group.rawValue)
            .addSnapshotListener { snapshot, error in
                guard let snapshot = snapshot, error == nil else { fatalError("userGroup snapshot error occured!!") }
                
                do {
                    let groups = try snapshot.documents
                        .map { try $0.data(as: UserGroupResponseDTO.self) }
                        .map { $0.toDomain() }
                    
                    completion(groups)
                } catch {
                    fatalError("\(error)")
                }
            }
    }
    
    func updateUserGroup(userID: String, groupID: String, userGroup: UserGroup) async throws {
        let userGroupID = try await firestore
            .collection(FirestorePath.user.rawValue)
            .document(userID)
            .collection(FirestorePath.group.rawValue)
            .whereField("groupID", in: [groupID])
            .getDocuments()
            .documents
            .compactMap { try? $0.data(as: UserGroupResponseDTO.self) }
            .first?.uid
        
        if let userGroupID = userGroupID {
            do {
                try firestore.collection(FirestorePath.user.rawValue)
                    .document(userID)
                    .collection(FirestorePath.group.rawValue)
                    .document(userGroupID)
                    .setData(from: makeUserGroupResponseDTO(userGroup: userGroup))
            }
        }
    }
    
    func deleteUserGroup(userID: String, groupID: String) {
        firestore
            .collection(FirestorePath.user.rawValue)
            .document(userID)
            .collection(FirestorePath.group.rawValue)
            .whereField("groupID", isEqualTo: groupID)
            .limit(to: 1)
            .getDocuments { snapshot, error in
                if let error = error {
                    print(error)
                } else {
                    snapshot?.documents.first?.reference.delete()
                }
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
    
    private func makeUserGroupResponseDTO(userGroup: UserGroup) -> UserGroupResponseDTO {
        return UserGroupResponseDTO(groupID: userGroup.groupID, time: userGroup.time)
    }
}
