//
//  AddGroupCoordinator.swift
//  DevFriends
//
//  Created by 이대현 on 2022/11/29.
//

import UIKit

protocol AddGroupFlowCoordinatorDependencies {
    func makeAddGroupViewController(groupType: GroupType, actions: AddGroupViewModelActions) -> AddGroupViewController
    func makeCategoryViewController() -> ChooseCategoryViewController
    func makeLocationViewController() -> ChooseLocationViewController
}

final class AddGroupCoordinator: Coordinator {
    let navigationController: UINavigationController
    let dependencies: AddGroupFlowCoordinatorDependencies
    
    var childCoordinators: [Coordinator] = []
    
    init(
        navigationController: UINavigationController,
        dependencies: AddGroupFlowCoordinatorDependencies
    ) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start(_ groupType: GroupType) {
        let actions = AddGroupViewModelActions(
            showCategoryView: showCategoryViewController,
            showLocationView: showLocationViewController)
        let addGroupViewController = dependencies.makeAddGroupViewController(groupType: groupType, actions: actions)
        navigationController.pushViewController(addGroupViewController, animated: false)
    }
}

extension AddGroupCoordinator {
    func showCategoryViewController() {
        let categoryViewController = dependencies.makeCategoryViewController()
        navigationController.pushViewController(categoryViewController, animated: true)
    }
    
    func showLocationViewController() {
        let locationViewController = dependencies.makeLocationViewController()
        navigationController.pushViewController(locationViewController, animated: true)
    }
}
