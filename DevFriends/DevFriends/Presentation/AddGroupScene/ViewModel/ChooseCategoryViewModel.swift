//
//  ChooseCategoryViewModel.swift
//  DevFriends
//
//  Created by 이대현 on 2022/11/29.
//

import Combine
import Foundation

struct ChooseCategoryViewModelActions {
    let didDisappearCategoryView: ([Category]) -> Void
}

protocol ChooseCategoryViewModelInput {
    func loadCategories()
    func sendCategorySelection()
    func addCategory(category: Category)
    func removeCategory(category: Category)
}

protocol ChooseCategoryViewModelOutput {
    var didUpdateSelectionSubject: PassthroughSubject<Void, Never> { get }
}

protocol ChooseCategoryViewModel: ChooseCategoryViewModelInput, ChooseCategoryViewModelOutput {
    var categoryType: [Category] { get set }
    var categoryFilter: [Category] { get set }
}

final class DefaultChooseCategoryViewModel: ChooseCategoryViewModel {
    var categoryType: [Category] = []
    var categoryFilter: [Category] = []
    
    private let fetchCategoryUseCase: FetchCategoryUseCase
    private let actions: ChooseCategoryViewModelActions?
    
    init(fetchCategoryUseCase: FetchCategoryUseCase, actions: ChooseCategoryViewModelActions) {
        self.fetchCategoryUseCase = fetchCategoryUseCase
        self.actions = actions
    }
    
    // MARK: OUTPUT
    var didUpdateSelectionSubject = PassthroughSubject<Void, Never>()
}

extension DefaultChooseCategoryViewModel {
    func loadCategories() {
        Task {
            let categories: [Category] = try await fetchCategoryUseCase.execute()
            self.categoryType = categories
            didUpdateSelectionSubject.send()
        }
    }
    
    func sendCategorySelection() {
        actions?.didDisappearCategoryView(self.categoryFilter)
    }
    
    func addCategory(category: Category) {
        guard !self.categoryFilter.contains(category) else { return }
        self.categoryFilter.append(category)
    }
    
    func removeCategory(category: Category) {
        if let index = self.categoryFilter.firstIndex(of: category) {
            self.categoryFilter.remove(at: index)
        }
    }
}
