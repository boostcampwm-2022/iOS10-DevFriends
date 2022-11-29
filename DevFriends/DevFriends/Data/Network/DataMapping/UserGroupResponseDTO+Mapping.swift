//
//  UserGroupResponseDTO+Mapping.swift
//  DevFriends
//
//  Created by 유승원 on 2022/11/28.
//

import Foundation
import FirebaseFirestoreSwift

struct UserGroupResponseDTO: Codable {
    @DocumentID var uid: String?
    let groupID: String
    let time: Date
}

extension UserGroupResponseDTO {
    func toDomain() -> UserGroup {
        return UserGroup(groupID: self.groupID, time: self.time)
    }
}
