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
    func makeNotificationViewController(actions: NotificationViewModelActions) -> NotificationViewController
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

extension GroupListCoordinator {
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
        let actions = NotificationViewModelActions() // TODO: 미래에 댓글 눌렀을 때 모임상세화면의 댓글로 이동하는 코드를 위해..
        let notificationViewController = dependencies.makeNotificationViewController(actions: actions)
        navigationController.pushViewController(notificationViewController, animated: true)
    }
}
