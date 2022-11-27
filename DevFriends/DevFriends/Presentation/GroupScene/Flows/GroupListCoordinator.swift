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
        let actions = GroupListViewModelActions(
            showGroupFilterView: showGroupFilterViewController,
            showNotifications: showNotificationViewController
        )
        let groupListViewController = dependencies.makeGroupListViewController(actions: actions)
        navigationController.pushViewController(groupListViewController, animated: false)
    }
}

extension GroupListCoordinator: GroupListViewCoordinator {
    func showGroupFilterViewController(filter: Filter) {
        let actions = GroupFilterViewModelActions(didDisappearFilterView: updateFilterGroup)
        let groupFilterViewController = dependencies.makeGroupFilterViewController(filter: filter, actions: actions)
//        navigationController.pushViewController(groupFilterViewController, animated: true)
        navigationController.present(groupFilterViewController, animated: true)
    }
    
    func updateFilterGroup(updatedFilter: Filter) {
        guard let groupListViewController = navigationController.viewControllers.last as? GroupListViewController else { return }
        groupListViewController.didSelectFilter(filter: updatedFilter)
    }
    
    func showNotificationViewController() {
        let notificationSceneDIContainer = NotificationSceneDIContainer()
        let notificationCoordinator = NotificationCoordinator(
            navigationController: navigationController,
            dependencies: notificationSceneDIContainer
        )
        childCoordinators.append(notificationCoordinator)
        notificationCoordinator.start()
    }
}
