//
//  FetchCategoryUseCase.swift
//  DevFriends
//
//  Created by 상현 on 2022/11/22.
//

import Foundation

protocol FetchCategoryUseCase {
    func execute() async throws -> [Category]
    func execute(categoryIds: [String]) async throws -> [Category]
}

final class DefaultFetchCategoryUseCase: FetchCategoryUseCase {
    private let categoryRepository: CategoryRepository
    
    init(categoryRepository: CategoryRepository) {
        self.categoryRepository = categoryRepository
    }
    
    func execute() async throws -> [Category] {
        return try await categoryRepository.fetch()
    }
    func execute(categoryIds: [String]) async throws -> [Category] {
        return try await self.categoryRepository.fetch(categoryIds)
    }
}