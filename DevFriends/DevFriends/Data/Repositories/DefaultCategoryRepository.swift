//
//  DefaultCategoryRepository.swift
//  DevFriends
//
//  Created by 상현 on 2022/11/22.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

final class DefaultCategoryRepository: CategoryRepository {
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
