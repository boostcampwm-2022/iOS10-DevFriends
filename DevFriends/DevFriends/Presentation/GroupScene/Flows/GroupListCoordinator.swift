//
//  GroupListCoordinator.swift
//  DevFriends
//
//  Created by 이대현 on 2022/11/24.
//

import UIKit

protocol GroupFlowCoordinatorDependencies {
    func makeGroupListViewController(actions: GroupListViewModelActions) -> GroupListViewController
    func makeGroupFilterViewController(filter: Filter, actions: GroupFilterViewModelActions) -> GroupFilterViewController
    func makeAddGroupSceneDIContainer() -> AddGroupSceneDIContainer
}

final class GroupListCoordinator: Coordinator {
    let navigationController: UINavigationController
    let dependencies: GroupFlowCoordinatorDependencies
    
    var childCoordinators: [Coordinator] = []
    
    init(navigationController: UINavigationController, dependencies: GroupFlowCoordinatorDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        let actions = GroupListViewModelActions(showGroupFilterView: showGroupFilterViewController, startAddGroupScene: startAddGroupScene)
        let groupListViewController = dependencies.makeGroupListViewController(actions: actions)
        navigationController.pushViewController(groupListViewController, animated: false)
    }
}

extension GroupListCoordinator: GroupListViewCoordinator {
    func showGroupFilterViewController(filter: Filter) {
        let actions = GroupFilterViewModelActions(didDisappearFilterView: updateFilterGroup)
        let groupFilterViewController = dependencies.makeGroupFilterViewController(filter: filter, actions: actions)
        navigationController.present(groupFilterViewController, animated: true)
    }
    
    func startAddGroupScene(groupType: GroupType) {
        let addGroupDIContainer = dependencies.makeAddGroupSceneDIContainer()
        let flow = addGroupDIContainer.makeAddGroupFlowCoordinator(
            navigationController: self.navigationController,
            groupType: groupType)
        flow.start()
        childCoordinators.append(flow)
    }
    
    func updateFilterGroup(updatedFilter: Filter) {
        guard let groupListViewController = navigationController.viewControllers.last as? GroupListViewController else { return }
        groupListViewController.didSelectFilter(filter: updatedFilter)
    }
}
