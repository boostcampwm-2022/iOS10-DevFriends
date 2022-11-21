//
//  GroupListViewModel.swift
//  DevFriends
//
//  Created by 이대현 on 2022/11/19.
//

import Foundation
import Combine

protocol GroupListViewModelInput {
    func loadGroupList() async
}

protocol GroupListViewModelOutput {
    var recommandGroupsSubject: CurrentValueSubject<[GroupCellInfo], Never> { get }
    var filteredGroupsSubject: CurrentValueSubject<[GroupCellInfo], Never> { get }
}

protocol GroupListViewModel: GroupListViewModelInput, GroupListViewModelOutput {}

final class DefaultGroupListViewModel: GroupListViewModel {
    private let fetchGroupUseCase: FetchGroupUseCase
    private let fetchGroupCellInfoUseCase: FetchGroupCellInfoUseCase
    
    init(fetchGroupUseCase: FetchGroupUseCase, fetchGroupCellInfoUseCase: FetchGroupCellInfoUseCase) {
        self.fetchGroupUseCase = fetchGroupUseCase
        self.fetchGroupCellInfoUseCase = fetchGroupCellInfoUseCase
    }
    
    // MARK: OUTPUT
    var recommandGroupsSubject = CurrentValueSubject<[GroupCellInfo], Never>([])
    var filteredGroupsSubject = CurrentValueSubject<[GroupCellInfo], Never>([])
}

// MARK: INPUT
extension DefaultGroupListViewModel {
    func loadGroupList() {
        Task {
            let groups = try await fetchGroupUseCase
                .execute(groupType: nil, location: nil)
            let groupCellInfo = await fetchGroupCellInfoUseCase
                .execute(groupsData: groups)
            recommandGroupsSubject.send(groupCellInfo) // TODO: 이후에 필터링 진행
            
            let testCellInfo = await fetchGroupCellInfoUseCase
            // TODO: Problem
            // 여기서 Cell info를 한번더 불러오는건 원래는 아주 낭비인데,
            // 이렇게 해서 UUID를 다른 값으로 초기화시키지 않으면, 같은 아이템의 경우 표시가 정상적으로 되지 않는다
                .execute(groupsData: groups)
            filteredGroupsSubject.send(testCellInfo) // TODO: 이후에 필터링 진행
        }
    }
}
