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
}

protocol GroupListViewModelOutput {
    var recommandGroupsSubject: CurrentValueSubject<[GroupCellInfo], Never> { get }
    var filteredGroupsSubject: CurrentValueSubject<[GroupCellInfo], Never> { get }
}

protocol GroupListViewModel: GroupListViewModelInput, GroupListViewModelOutput {}

final class DefaultGroupListViewModel: GroupListViewModel {
    private let groupListUseCase = DefaultLoadGroupListUseCase()
    
    // MARK: OUTPUT
    var recommandGroupsSubject = CurrentValueSubject<[GroupCellInfo], Never>([])
    var filteredGroupsSubject = CurrentValueSubject<[GroupCellInfo], Never>([])
}

// MARK: INPUT
extension DefaultGroupListViewModel {
    func loadGroupList() {
        recommandGroupsSubject.send(groupListUseCase.fetchRecommandGroups()) // TODO: Refactor
        filteredGroupsSubject.send(groupListUseCase.execute())
    }
}
