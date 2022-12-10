//
//  DefaultCategoryRepository.swift
//  DevFriends
//
//  Created by 상현 on 2022/11/22.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

final class DefaultCategoryRepository: ContainsFirestore {}

extension DefaultCategoryRepository: CategoryRepository {
    func fetch(_ categoryIds: [String]) async throws -> [Category] {
        return try await withThrowingTaskGroup(of: Category.self) { taskGroup in
            categoryIds.forEach { id in
                if !id.isEmpty {
                    taskGroup.addTask {
                        try await self.fetchCategory(id)
                    }
                }
            }
            
            return try await taskGroup.reduce(into: []) { $0.append($1) }
        }
    }
    
    func fetch() async throws -> [Category] {
        var categories: [Category] = []
        let snapshot = try await firestore.collection(FirestorePath.category.rawValue).getDocuments()
        
        for document in snapshot.documents {
            let categoryData = document.data()
            if let categoryString = categoryData["name"] as? String {
                let category = Category(id: document.documentID, name: categoryString)
                CategoryCacheManager.shared.save(category: category)
                categories.append(category)
            }
        }
        return categories
    }
}
 
// MARK: Private
extension DefaultCategoryRepository {
    private func fetchCategory(_ id: String) async throws -> Category {
        if let category = CategoryCacheManager.shared.fetch(id: id) {
            return category
        }
        let snapshot = try await firestore.collection(FirestorePath.category.rawValue).document(id).getDocument()
        let category = try snapshot.data(as: CategoryResponseDTO.self).toDomain()
        CategoryCacheManager.shared.save(category: category)
        return category
    }
}
