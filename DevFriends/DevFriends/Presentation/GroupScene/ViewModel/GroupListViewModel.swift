//
//  GroupListViewModel.swift
//  DevFriends
//
//  Created by 이대현 on 2022/11/19.
//

import Foundation
import Combine

protocol GroupListViewModelInput {
//    func didLoadGroupList()
}

protocol GroupListViewModelOutput {
    var groupListSubject: CurrentValueSubject<[GroupCellInfo], Never> { get }
}

protocol GroupListViewModel: GroupListViewModelInput, GroupListViewModelOutput {}

final class DefaultGroupListViewModel: GroupListViewModel {
    private let groupListUseCase = DefaultLoadGroupListUseCase()
    
    // MARK: OUTPUT
    var groupListSubject = CurrentValueSubject<[GroupCellInfo], Never>([])
    
    @Published var recommandGroups: [GroupCellInfo] = []
    @Published var filteredGroups: [GroupCellInfo] = []
    
    func fetchRecommandGroups() {
        recommandGroups = groupListUseCase.fetchRecommandGroups()
    }
    
    func fetchFilteredGroups() {
        filteredGroups = groupListUseCase.fetchAllGroups()
        // 여기에 필터 정보를 바탕으로 sorting 진행
    }
}
