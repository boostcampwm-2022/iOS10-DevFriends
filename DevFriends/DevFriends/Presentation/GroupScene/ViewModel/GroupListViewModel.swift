//
//  GroupListViewModel.swift
//  DevFriends
//
//  Created by 이대현 on 2022/11/19.
//

import Foundation
import Combine

protocol GroupListViewModelInput {
    func loadGroupList()
    func updateFilter(filter: Filter)
}

protocol GroupListViewModelOutput {
    var recommandGroupsSubject: CurrentValueSubject<[GroupCellInfo], Never> { get }
    var filteredGroupsSubject: CurrentValueSubject<[GroupCellInfo], Never> { get }
}

protocol GroupListViewModel: GroupListViewModelInput, GroupListViewModelOutput {
    var recommandFilter: Filter { get set }
    var groupFilter: Filter { get set }
}

final class DefaultGroupListViewModel: GroupListViewModel {
    private let fetchGroupUseCase: FetchGroupUseCase
    var recommandFilter: Filter
    var groupFilter: Filter = Filter(alignFilter: .newest, categoryFilter: [])
    
    init(fetchGroupUseCase: FetchGroupUseCase) {
        self.fetchGroupUseCase = fetchGroupUseCase
        // 추천 필터는 나중에 사용자 정보 받아와서 업데이트
        self.recommandFilter = Filter(alignFilter: .newest, categoryFilter: [])
    }
    
    // MARK: OUTPUT
    var recommandGroupsSubject = CurrentValueSubject<[GroupCellInfo], Never>([])
    var filteredGroupsSubject = CurrentValueSubject<[GroupCellInfo], Never>([])
}

// MARK: INPUT
extension DefaultGroupListViewModel {
    func loadGroupList() {
        Task {
            let recommandGroups = try await fetchGroupUseCase
                .execute(filter: self.recommandFilter)
            // 셀의 중복 방지를 위해, uuid 정보가 있는 GroupCellInfo로 한번 더 mapping 해줬습니다
            let recommandGroupCellInfos = recommandGroups.map { GroupCellInfo(group: $0) }
            recommandGroupsSubject.send(recommandGroupCellInfos)
            
            let filteredGroups = try await fetchGroupUseCase
                .execute(filter: self.groupFilter)
            let filteredGroupCellInfos = filteredGroups.map { GroupCellInfo(group: $0) }
            filteredGroupsSubject.send(filteredGroupCellInfos)
        }
    }
    func updateFilter(filter: Filter) {
        self.groupFilter = filter
    }
}
