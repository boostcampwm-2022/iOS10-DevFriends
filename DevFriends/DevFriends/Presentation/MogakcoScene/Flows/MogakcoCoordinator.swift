//
//  MogakcoCoordinator.swift
//  DevFriends
//
//  Created by 상현 on 2022/11/24.
//

import UIKit

protocol MogakcoFlowCoordinatorDependencies {
    func makeMogakcoViewController(actions: MogakcoViewModelActions) -> MogakcoViewController
    func makeGroupDetailViewController(group: Group) -> PostDetailViewController
}

final class MogakcoCoordinator: Coordinator {
    let navigationController: UINavigationController
    let dependencies: MogakcoFlowCoordinatorDependencies

    var childCoordinators: [Coordinator] = []
    
    init(
        navigationController: UINavigationController,
        dependencies: MogakcoFlowCoordinatorDependencies
    ) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        let actions = MogakcoViewModelActions(
            showGroupDetail: showGroupDetailViewController,
            showNotifications: showNotificationViewController
        )
        let mogakcoViewController = dependencies.makeMogakcoViewController(actions: actions)
        navigationController.navigationBar.topItem?.title = "모각코"
        navigationController.pushViewController(mogakcoViewController, animated: false)
    }
}

extension MogakcoCoordinator: GroupDetailCoordinator {
    func showGroupDetailViewController(group: Group) {
        let postDetailViewController = dependencies.makeGroupDetailViewController(group: group)
        navigationController.pushViewController(postDetailViewController, animated: true)
        navigationController.tabBarController?.tabBar.isHidden = true
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
