//
//  GroupFilterViewModel.swift
//  DevFriends
//
//  Created by 이대현 on 2022/11/22.
//

import Foundation
import Combine

struct GroupFilterViewModelActions {
    let didDisappearFilterView: (Filter) -> Void
}

protocol GroupFilterViewModelInput {
    func loadCategories()
    func sendFilter(filter: Filter)
    func initFilter(filter: Filter)
    func setAlignFilter(type: AlignType)
    func setGroupFilter(type: GroupType)
    func removeAllGroupFilter()
    func setCategoryFilter(category: String)
    func removeCategoryFilter(category: String)
}

protocol GroupFilterViewModelOutput {
    var didUpdateFilterSubject: PassthroughSubject<Void, Never> { get }
}

protocol GroupFilterViewModel: GroupFilterViewModelInput, GroupFilterViewModelOutput {
    var alignType: [AlignType] { get set }
    var groupType: [GroupType] { get set }
    var categoryType: [String] { get set }
    var alignFilter: AlignType { get set }
    var groupFilter: GroupType? { get set }
    var categoryFilter: [String] { get set }
}

final class DefaultGroupFilterViewModel: GroupFilterViewModel {
    var alignType: [AlignType] = [.newest, .closest]
    var groupType: [GroupType] = [.mogakco, .project, .study]
    var categoryType: [String] = []
    var alignFilter: AlignType = .newest
    var groupFilter: GroupType?
    var categoryFilter: [String] = []
    
    private let fetchCategoryUseCase: FetchCategoryUseCase
    private let actions: GroupFilterViewModelActions?
    
    init(fetchCategoryUseCase: FetchCategoryUseCase, actions: GroupFilterViewModelActions) {
        self.fetchCategoryUseCase = fetchCategoryUseCase
        self.actions = actions
    }
    
    // MARK: OUTPUT
    var didUpdateFilterSubject = PassthroughSubject<Void, Never>()
}

// MARK: INPUT
extension DefaultGroupFilterViewModel {
    func loadCategories() {
        Task {
            let categories: [Category] = try await fetchCategoryUseCase.execute()
            self.categoryType = categories.map { return $0.name }
            didUpdateFilterSubject.send()
        }
    }
    func sendFilter(filter: Filter) {
        actions?.didDisappearFilterView(filter)
    }
    func initFilter(filter: Filter) {
        self.alignFilter = filter.alignFilter
        self.groupFilter = filter.groupFilter
        self.categoryFilter = filter.categoryFilter
        didUpdateFilterSubject.send()
    }
    func setAlignFilter(type: AlignType) {
        self.alignFilter = type
        didUpdateFilterSubject.send()
    }
    func setGroupFilter(type: GroupType) {
        self.groupFilter = type
        didUpdateFilterSubject.send()
    }
    func removeAllGroupFilter() {
        self.groupFilter = nil
        didUpdateFilterSubject.send()
    }
    func setCategoryFilter(category: String) {
        guard !self.categoryFilter.contains(category) else { return }
        self.categoryFilter.append(category)
        didUpdateFilterSubject.send()
    }
    func removeCategoryFilter(category: String) {
        if let index = self.categoryFilter.firstIndex(of: category) {
            self.categoryFilter.remove(at: index)
            didUpdateFilterSubject.send()
        }
    }
}
