//
//  AddGroupCoordinator.swift
//  DevFriends
//
//  Created by 이대현 on 2022/11/29.
//

import UIKit

protocol AddGroupFlowCoordinatorDependencies {
    func makeAddGroupViewController(groupType: GroupType, actions: AddGroupViewModelActions) -> AddGroupViewController
    func makeCategoryViewController(actions: ChooseCategoryViewModelActions) -> ChooseCategoryViewController
    func makeLocationViewController(actions: ChooseLocationViewActions) -> ChooseLocationViewController
}

final class AddGroupCoordinator: Coordinator {
    let navigationController: UINavigationController
    let dependencies: AddGroupFlowCoordinatorDependencies
    let groupType: GroupType
    
    var childCoordinators: [Coordinator] = []
    
    init(
        navigationController: UINavigationController,
        dependencies: AddGroupFlowCoordinatorDependencies,
        groupType: GroupType
    ) {
        self.navigationController = navigationController
        self.dependencies = dependencies
        self.groupType = groupType
    }
    
    func start() {
        let actions = AddGroupViewModelActions(
            showCategoryView: showCategoryViewController,
            showLocationView: showLocationViewController)
        let addGroupViewController = dependencies.makeAddGroupViewController(groupType: self.groupType, actions: actions)
        navigationController.pushViewController(addGroupViewController, animated: false)
    }
}

extension AddGroupCoordinator {
    func showCategoryViewController() {
        let actions = ChooseCategoryViewModelActions(didSubmitCategory: didSubmitCategorySelection)
        let categoryViewController = dependencies.makeCategoryViewController(actions: actions)
        navigationController.pushViewController(categoryViewController, animated: true)
    }
    
    func showLocationViewController() {
        let actions = ChooseLocationViewActions(didSubmitLocation: didSubmitLocationSelection)
        let locationViewController = dependencies.makeLocationViewController(actions: actions)
        navigationController.pushViewController(locationViewController, animated: true)
    }
    
    func didSubmitCategorySelection(updatedCategories: [Category]) {
        navigationController.popViewController(animated: true)
        guard let addGroupViewController = navigationController.viewControllers.last as? AddGroupViewController else { return }
        addGroupViewController.updateCategories(categories: updatedCategories)
    }
    
    func didSubmitLocationSelection(updatedLocation: Location) {
        navigationController.popViewController(animated: true)
        guard let addGroupViewController = navigationController.viewControllers.last as? AddGroupViewController else { return }
        addGroupViewController.updateLocation(location: updatedLocation)

    }
}
