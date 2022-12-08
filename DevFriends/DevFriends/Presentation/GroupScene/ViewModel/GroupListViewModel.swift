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
    let showPostDetailScene: (Group) -> Void
}

protocol GroupListViewModelInput {
    func loadUserRecommand()
    func loadGroupList()
    func didSelectFilter()
    func didSelectAdd(groupType: GroupType)
    func updateFilter(filter: Filter)
    func didSelectNotifications()
    func didSelectGroupCell(indexPath: IndexPath)
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
    private let actions: GroupListViewModelActions
    private let sortGroupUseCase: SortGroupUseCase
    private let loadCategoryUseCase: LoadCategoryUseCase
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
        self.loadCategoryUseCase = fetchCategoryUseCase
        // 추천 필터는 나중에 사용자 정보 받아와서 업데이트
        self.recommandFilter = Filter(alignFilter: .closest, categoryFilter: [])
        self.actions = actions
    }
    
    // MARK: OUTPUT
    var recommandGroupsSubject = CurrentValueSubject<[GroupCellInfo], Never>([])
    var filteredGroupsSubject = CurrentValueSubject<[GroupCellInfo], Never>([])
    var filteredGroupAlignTypeSubject = PassthroughSubject<AlignType, Never>()
}

// MARK: INPUT
extension DefaultGroupListViewModel {
    func loadUserRecommand() {
        Task {
            if let userCategoryIDs = UserManager.shared.categoryIDs {
                self.recommandFilter.categoryFilter = userCategoryIDs
            }
        }
    }
    
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
                // 참가인원 다 찼으면 패스
                if group.participantIDs.count >= group.limitedNumberPeople {
                    continue
                }
                let categories = await loadCategories(categoryIDs: group.categoryIDs)
                var distance: Double?
                if let userLocation = userLocation {
                    distance = group.location.distance(from: userLocation)
                }
                recommandGroupCellInfos.append(GroupCellInfo(
                    section: .recommand,
                    group: group,
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
                // 참가인원 다 찼으면 패스
                if group.participantIDs.count >= group.limitedNumberPeople {
                    continue
                }
                let categories = await loadCategories(categoryIDs: group.categoryIDs)
                var distance: Double?
                if let userLocation = userLocation {
                    distance = group.location.distance(from: userLocation)
                }
                filteredGroupCellInfos.append(GroupCellInfo(
                    section: .filtered,
                    group: group,
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
                try await loadCategoryUseCase.execute(categoryIds: categoryIDs)
            }.result.get()
        } catch {
            print(error)
        }
        return result
    }
    
    func didSelectFilter() {
        actions.showGroupFilterView(groupFilter)
    }
    
    func didSelectAdd(groupType: GroupType) {
        actions.startAddGroupScene(groupType)
    }
    
    func updateFilter(filter: Filter) {
        groupFilter = filter
        filteredGroupAlignTypeSubject.send(filter.alignFilter)
    }
    
    func didSelectNotifications() {
        actions.showNotifications()
    }
    
    func didSelectGroupCell(indexPath: IndexPath) {
        if indexPath.section == GroupListSection.recommand.rawValue {
            let group = recommandGroupsSubject.value[indexPath.row]
            actions.showPostDetailScene(group.group)
        } else if indexPath.section == GroupListSection.filtered.rawValue {
            let group = filteredGroupsSubject.value[indexPath.row]
            actions.showPostDetailScene(group.group)
        }
        
    }
    
    func didUpdateUserLocation(location: Location) {
        self.userLocation = location
    }
}
