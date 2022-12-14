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
    func makeNotificationViewController(actions: NotificationViewModelActions) -> NotificationViewController
    func makePostDetailViewController(actions: PostDetailViewModelActions, group: Group) -> PostDetailViewController
    func makePostReportViewController(actions: PostReportViewControllerActions) -> PostReportViewController
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
            startAddGroupScene: startAddGroupScene,
            showNotifications: showNotificationViewController,
            showPostDetailScene: showGroupDetailViewController
        )
        let groupListViewController = dependencies.makeGroupListViewController(actions: actions)
        navigationController.pushViewController(groupListViewController, animated: false)
    }
}

extension GroupListCoordinator {
    func showGroupFilterViewController(filter: Filter) {
        let actions = GroupFilterViewModelActions(didDisappearFilterView: updateFilterGroup)
        let groupFilterViewController = dependencies.makeGroupFilterViewController(filter: filter, actions: actions)
        navigationController.present(groupFilterViewController, animated: true)
    }
    
    func startAddGroupScene(groupType: GroupType) {
        let addGroupDIContainer = dependencies.makeAddGroupSceneDIContainer()
        let flow = addGroupDIContainer.makeAddGroupFlowCoordinator(
            navigationController: self.navigationController,
            groupType: groupType
        )
        flow.start()
        childCoordinators.append(flow)
    }
    
    func updateFilterGroup(updatedFilter: Filter) {
        guard let groupListViewController = navigationController.viewControllers.last as? GroupListViewController else { return }
        groupListViewController.didSelectFilter(filter: updatedFilter)
    }
    
    func showNotificationViewController() {
        let actions = NotificationViewModelActions(moveBackToPrevViewController: moveBackToGroupListViewController) // TODO: 미래에 댓글 눌렀을 때 모임상세화면의 댓글로 이동하는 코드를 위해..
        let notificationViewController = dependencies.makeNotificationViewController(actions: actions)
        navigationController.pushViewController(notificationViewController, animated: true)
        navigationController.tabBarController?.tabBar.isHidden = true
    }
    
    func showGroupDetailViewController(group: Group) {
        let actions = PostDetailViewModelActions(
            backToPrevViewController: moveBackToGroupListViewController,
            report: showPostReportViewController
        )
        let postDetailViewController = dependencies.makePostDetailViewController(actions: actions, group: group)
        navigationController.pushViewController(postDetailViewController, animated: true)
        navigationController.tabBarController?.tabBar.isHidden = true
    }
    
    func moveBackToGroupListViewController() {
        navigationController.tabBarController?.tabBar.isHidden = false
        navigationController.popViewController(animated: true)
    }
    
    func showPostReportViewController() {
        let acitons = PostReportViewControllerActions(
            submit: popViewControllerWithHiddenTabBar,
            close: popViewControllerWithHiddenTabBar
        )
        let postReportViewController = dependencies.makePostReportViewController(actions: acitons)
        navigationController.pushViewController(postReportViewController, animated: true)
    }
    
    func popViewControllerWithHiddenTabBar() {
        navigationController.popViewController(animated: true)
        navigationController.tabBarController?.tabBar.isHidden = true
    }
}
