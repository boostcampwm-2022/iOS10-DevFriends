//
//  DefaultCategoryRepository.swift
//  DevFriends
//
//  Created by 이대현 on 2022/11/22.
//

import FirebaseFirestore
import Foundation

class DefaultCategoryRepository: CategoryRepository {
    let firestore = Firestore.firestore()
    
    func fetch() async throws -> [Category] {
        var categories: [Category] = []
        let snapshot = try await firestore.collection("Category").getDocuments()
        
        for document in snapshot.documents {
            let categoryData = document.data()
            if let categoryString = categoryData["name"] as? String {
                categories.append(Category(name: categoryString))
            }
        }
        return categories
    }
}
