//
//  AddGroupViewModel.swift
//  DevFriends
//
//  Created by 이대현 on 2022/11/23.
//

import Combine
import Foundation

struct AddGroupViewModelActions {
    let showCategoryView: () -> Void
    let showLocationView: () -> Void
}

protocol AddGroupViewModelInput {
    func didCategorySelect()
    func didLocationSelect()
}

protocol AddGroupViewModelOutput {
    
}

protocol AddGroupViewModel: AddGroupViewModelInput, AddGroupViewModelOutput {
    
}

final class DefaultAddGroupViewModel: AddGroupViewModel {
    private let actions: AddGroupViewModelActions?
    
    init(actions: AddGroupViewModelActions) {
        self.actions = actions
    }
    
}

// MARK: INPUT
extension DefaultAddGroupViewModel {
    func didCategorySelect() {
        actions?.showCategoryView()
    }
    
    func didLocationSelect() {
        actions?.showLocationView()
    }
}
