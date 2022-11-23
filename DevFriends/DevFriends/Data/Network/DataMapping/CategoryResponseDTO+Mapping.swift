//
//  CategoryResponseDTO+Mapping.swift
//  DevFriends
//
//  Created by 상현 on 2022/11/22.
//

import Foundation
import FirebaseFirestoreSwift

struct CategoryResponseDTO: Codable {
    @DocumentID var uid: String?
    let name: String
}

extension CategoryResponseDTO {
    func toDomain() -> Category {
        return Category(
            id: uid ?? "",
            name: name
        )
    }
}
        
