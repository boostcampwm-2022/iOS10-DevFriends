//
//  GroupListViewModel.swift
//  DevFriends
//
//  Created by 이대현 on 2022/11/19.
//

import Combine
import Foundation

struct GroupListViewModelActions {
    let showGroupFilterView: (Filter) -> Void
    let startAddGroupScene: (GroupType) -> Void
    let showNotifications: () -> Void
}

protocol GroupListViewModelInput {
    func loadGroupList()
    func didSelectFilter()
    func didSelectAdd(groupType: GroupType)
    func updateFilter(filter: Filter)
    func didSelectNotifications()
    func didUpdateUserLocation(location: Location)
}

protocol GroupListViewModelOutput {
    var recommandGroupsSubject: CurrentValueSubject<[GroupCellInfo], Never> { get }
    var filteredGroupsSubject: CurrentValueSubject<[GroupCellInfo], Never> { get }
    var filteredGroupAlignTypeSubject: PassthroughSubject<AlignType, Never> { get }
}

protocol GroupListViewModel: GroupListViewModelInput, GroupListViewModelOutput {
    var recommandFilter: Filter { get set }
    var groupFilter: Filter { get set }
}

final class DefaultGroupListViewModel: GroupListViewModel {
    private let fetchGroupUseCase: LoadGroupUseCase
    private let sortGroupUseCase: SortGroupUseCase
    private let fetchCategoryUseCase: LoadCategoryUseCase
    private let actions: GroupListViewModelActions?
    private var userLocation: Location?
    var recommandFilter: Filter
    var groupFilter = Filter(alignFilter: .newest, categoryFilter: [])

    init(
        fetchGroupUseCase: LoadGroupUseCase,
        sortGroupUseCase: SortGroupUseCase,
        fetchCategoryUseCase: LoadCategoryUseCase,
        actions: GroupListViewModelActions
    ) {
        self.fetchGroupUseCase = fetchGroupUseCase
        self.sortGroupUseCase = sortGroupUseCase
        self.fetchCategoryUseCase = fetchCategoryUseCase
        // 추천 필터는 나중에 사용자 정보 받아와서 업데이트
        self.recommandFilter = Filter(alignFilter: .newest, categoryFilter: [])
        self.actions = actions
    }
    
    // MARK: OUTPUT
    var recommandGroupsSubject = CurrentValueSubject<[GroupCellInfo], Never>([])
    var filteredGroupsSubject = CurrentValueSubject<[GroupCellInfo], Never>([])
    var filteredGroupAlignTypeSubject = PassthroughSubject<AlignType, Never>()
}

// MARK: INPUT
extension DefaultGroupListViewModel {
    func loadGroupList() {
        Task {
            let recommandGroups = try await fetchGroupUseCase
                .execute(filter: self.recommandFilter)
            let sortedRecommand = sortGroupUseCase.execute(
                groups: recommandGroups,
                by: recommandFilter.alignFilter,
                userLocation: userLocation
            )
            var recommandGroupCellInfos: [GroupCellInfo] = []
            for group in sortedRecommand {
                let categories = await loadCategories(categoryIDs: group.categoryIDs)
                var distance: Double?
                if let userLocation = userLocation {
                    distance = group.location.distance(from: userLocation)
                }
                recommandGroupCellInfos.append(GroupCellInfo(
                    section: .recommand,
                    title: group.title,
                    categories: categories,
                    location: group.location,
                    distance: distance,
                    currentNumberPeople: group.participantIDs.count,
                    limitedNumberPeople: group.limitedNumberPeople
                ))
            }
            recommandGroupsSubject.send(recommandGroupCellInfos)
            
            let filteredGroups = try await fetchGroupUseCase
                .execute(filter: self.groupFilter)
            let sortedFiltered = sortGroupUseCase.execute(
                groups: filteredGroups,
                by: groupFilter.alignFilter,
                userLocation: userLocation
            )
            var filteredGroupCellInfos: [GroupCellInfo] = []
            for group in sortedFiltered {
                let categories = await loadCategories(categoryIDs: group.categoryIDs)
                var distance: Double?
                if let userLocation = userLocation {
                    distance = group.location.distance(from: userLocation)
                }
                filteredGroupCellInfos.append(GroupCellInfo(
                    section: .filtered,
                    title: group.title,
                    categories: categories,
                    location: group.location,
                    distance: distance,
                    currentNumberPeople: group.participantIDs.count,
                    limitedNumberPeople: group.limitedNumberPeople
                ))
            }
            filteredGroupsSubject.send(filteredGroupCellInfos)
        }
    }
    
    private func loadCategories(categoryIDs: [String]) async -> [Category] {
        var result: [Category] = []
        do {
            result = try await Task {
                try await fetchCategoryUseCase.execute(categoryIds: categoryIDs)
            }.result.get()
        } catch {
            print(error)
        }
        return result
    }
    
    func didSelectFilter() {
        actions?.showGroupFilterView(groupFilter)
    }
    
    func didSelectAdd(groupType: GroupType) {
        actions?.startAddGroupScene(groupType)
    }
    
    func updateFilter(filter: Filter) {
        groupFilter = filter
        filteredGroupAlignTypeSubject.send(filter.alignFilter)
    }
    
    func didSelectNotifications() {
        actions?.showNotifications()
    }
    
    func didUpdateUserLocation(location: Location) {
        self.userLocation = location
    }
}
