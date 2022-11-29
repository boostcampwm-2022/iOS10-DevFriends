//
//  AddGroupSceneDIContainer.swift
//  DevFriends
//
//  Created by 이대현 on 2022/11/29.
//

import UIKit

struct AddGroupSceneDIContainer {
    // MARK: Flow Coordinators
    func makeAddGroupFlowCoordinator(navigationController: UINavigationController) -> AddGroupCoordinator {
        return AddGroupCoordinator(navigationController: navigationController, dependencies: self)
    }
}

extension AddGroupSceneDIContainer: AddGroupFlowCoordinatorDependencies {
    
    // MARK: AddGroupView
    func makeAddGroupViewController(groupType: GroupType, actions: AddGroupViewModelActions) -> AddGroupViewController {
        return AddGroupViewController(viewModel: makeAddGroupViewModel(actions: actions), groupType: groupType)
    }
    
    func makeAddGroupViewModel(actions: AddGroupViewModelActions) -> AddGroupViewModel {
        return DefaultAddGroupViewModel(actions: actions)
    }
    
    // MARK: CategoryView
    func makeCategoryViewController() -> ChooseCategoryViewController {
        <#code#>
    }
    
    // MARK: LocationView
    func makeLocationViewController() -> ChooseLocationViewController {
        <#code#>
    }
    
    
}
