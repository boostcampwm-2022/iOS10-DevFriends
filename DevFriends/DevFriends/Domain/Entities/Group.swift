//
//  Group.swift
//  DevFriends
//
//  Created by 심주미 on 2022/11/14.
//

import Foundation
import FirebaseFirestoreSwift

struct Group: Codable, Hashable {
    @DocumentID var uid: String?
    let participantIDs: [String]
    let title: String
}
