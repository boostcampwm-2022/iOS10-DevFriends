//
//  Category.swift
//  DevFriends
//
//  Created by 상현 on 2022/11/22.
//

import Foundation
import FirebaseFirestoreSwift

struct Category: Codable {
    @DocumentID var uid: String?
    let name: String
}
