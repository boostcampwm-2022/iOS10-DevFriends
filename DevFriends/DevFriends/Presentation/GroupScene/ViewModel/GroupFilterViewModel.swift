//
//  GroupFilterViewModel.swift
//  DevFriends
//
//  Created by 이대현 on 2022/11/22.
//

import Foundation
import Combine

protocol GroupFilterViewModelInput {
    func loadCategories()
}

protocol GroupFilterViewModelOutput {
    var categoriesSubject: CurrentValueSubject<[Category], Never> { get }
}

protocol GroupFilterViewModel: GroupFilterViewModelInput, GroupFilterViewModelOutput {
    var alignType: [AlignType] { get set }
    var groupType: [GroupType] { get set }
}

final class DefaultGroupFilterViewModel: GroupFilterViewModel {
    var alignType: [AlignType] = [.newest, .closest]
    var groupType: [GroupType] = [.mogakco, .project, .study]
    
    private let fetchCategoryUseCase: FetchCategoryUseCase
    
    init(fetchCategoryUseCase: FetchCategoryUseCase) {
        self.fetchCategoryUseCase = fetchCategoryUseCase
    }
    
    // MARK: OUTPUT
    var categoriesSubject = CurrentValueSubject<[Category], Never>([])
}

// MARK: INPUT
extension DefaultGroupFilterViewModel {
    func loadCategories() {
        Task {
            let categories: [Category] = try await fetchCategoryUseCase.execute()
            categoriesSubject.send(categories)
        }
    }
}
