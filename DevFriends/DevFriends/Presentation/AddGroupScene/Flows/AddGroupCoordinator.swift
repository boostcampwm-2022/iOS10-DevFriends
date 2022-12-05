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
    private let navigationController: UINavigationController
    private let dependencies: AddGroupFlowCoordinatorDependencies
    private let groupType: GroupType
    
    private var childCoordinators: [Coordinator] = []
    
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
            showLocationView: showLocationViewController,
            moveBackToParent: moveBackToParent
        )
        let addGroupViewController = dependencies.makeAddGroupViewController(
            groupType: self.groupType,
            actions: actions
        )
        navigationController.pushViewController(addGroupViewController, animated: false)
        navigationController.tabBarController?.tabBar.isHidden = true
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
        guard let viewController = navigationController.viewControllers.last as? AddGroupViewController else { return }
        viewController.updateCategories(categories: updatedCategories)
    }
    
    func didSubmitLocationSelection(updatedLocation: Location) {
        navigationController.popViewController(animated: true)
        guard let viewController = navigationController.viewControllers.last as? AddGroupViewController else { return }
        viewController.updateLocation(location: updatedLocation)
    }
    
    func moveBackToParent() {
        navigationController.tabBarController?.tabBar.isHidden = false
        navigationController.popViewController(animated: true)
    }
}
