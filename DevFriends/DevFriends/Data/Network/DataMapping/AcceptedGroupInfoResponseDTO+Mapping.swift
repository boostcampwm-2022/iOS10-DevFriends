//
//  AcceptedGroupInfoResponseDTO+Mapping.swift
//  DevFriends
//
//  Created by 심주미 on 2022/11/28.
//

import Foundation
import FirebaseFirestoreSwift

struct AcceptedGroupInfoResponseDTO: Codable {
    let groupID: String
    let time: Date
}
