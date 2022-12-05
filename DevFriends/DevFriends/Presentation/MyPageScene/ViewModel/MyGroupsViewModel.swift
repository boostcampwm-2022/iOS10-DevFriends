//
//  MyGroupsViewModel.swift
//  DevFriends
//
//  Created by 심주미 on 2022/11/23.
//

import Foundation

struct MyGroupsViewModelActions {
    let back: () -> Void
}

final class MyGroupsViewModel {
    let type: MyGroupsType
    let actions: MyGroupsViewModelActions
    
    init(type: MyGroupsType, actions: MyGroupsViewModelActions) {
        self.type = type
        self.actions = actions
    }
    
    func getMyGroupsTypeName() -> String {
        return type.rawValue
    }
    
    func didTouchedBackButton() {
        actions.back()
    }
}
