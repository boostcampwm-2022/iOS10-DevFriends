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
    
    func fetch(_ categoryIds: [String]) async throws -> [Category] {
        return try await withThrowingTaskGroup(of: Category.self) { taskGroup in
            categoryIds.forEach { id in
                taskGroup.addTask {
                    try await self.fetchCategory(id)
                }
            }
            
            return try await taskGroup.reduce(into: []) { $0.append($1) }
        }
    }
    
    private func fetchCategory(_ id: String) async throws -> Category {
        let snapshot = try await firestore.collection("Category").document(id).getDocument()
        
        return try snapshot.data(as: CategoryResponseDTO.self).toDomain()
    }
}
