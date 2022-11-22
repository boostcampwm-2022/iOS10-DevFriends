//
//  FetchCategoryUseCase.swift
//  DevFriends
//
//  Created by 이대현 on 2022/11/22.
//

import Foundation

protocol FetchCategoryUseCase {
    func execute() async throws -> [Category]
}

final class DefaultFetchCategoryUseCase: FetchCategoryUseCase {
    let categoryRepository: CategoryRepository
    
    init(categoryRepository: CategoryRepository) {
        self.categoryRepository = categoryRepository
    }
    
    func execute() async throws -> [Category] {
        return try await categoryRepository.fetch()
    }
}
