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
    private let actions: GroupListViewModelActions?
    private var userLocation: Location?
    var recommandFilter: Filter
    var groupFilter = Filter(alignFilter: .newest, categoryFilter: [])

    init(
        fetchGroupUseCase: LoadGroupUseCase,
        sortGroupUseCase: SortGroupUseCase,
        actions: GroupListViewModelActions
    ) {
        self.fetchGroupUseCase = fetchGroupUseCase
        self.sortGroupUseCase = sortGroupUseCase
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
            // 셀의 중복 방지를 위해, uuid 정보가 있는 GroupCellInfo로 한번 더 mapping 해줬습니다
            let recommandGroupCellInfos = sortedRecommand.map { GroupCellInfo(group: $0, at: .recommand) }
            recommandGroupsSubject.send(recommandGroupCellInfos)
            
            let filteredGroups = try await fetchGroupUseCase
                .execute(filter: self.groupFilter)
            let sortedFiltered = sortGroupUseCase.execute(
                groups: filteredGroups,
                by: groupFilter.alignFilter,
                userLocation: userLocation
            )
            let filteredGroupCellInfos = sortedFiltered.map { GroupCellInfo(group: $0, at: .filtered) }
            filteredGroupsSubject.send(filteredGroupCellInfos)
        }
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
