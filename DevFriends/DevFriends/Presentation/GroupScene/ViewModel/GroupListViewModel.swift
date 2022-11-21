//
//  GroupListViewModel.swift
//  DevFriends
//
//  Created by 이대현 on 2022/11/19.
//

import Foundation

final class GroupListViewModel {
    let groupListUseCase = DefaultLoadGroupListUseCase()
    
    @Published var recommandGroups: [GroupCellInfo] = []
    @Published var filteredGroups: [GroupCellInfo] = []
    struct GroupListViewInput {
        
    }
    
    struct GroupListViewOutput {
        
    }
    
    func fetchRecommandGroups() {
        recommandGroups = groupListUseCase.fetchRecommandGroups()
    }
    
    func fetchFilteredGroups() {
        filteredGroups = groupListUseCase.fetchAllGroups()
        // 여기에 필터 정보를 바탕으로 sorting 진행
    }
}
