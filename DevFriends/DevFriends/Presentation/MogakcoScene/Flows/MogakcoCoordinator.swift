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
    func makeNotificationViewController(actions: NotificationViewModelActions) -> NotificationViewController
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

extension MogakcoCoordinator {
    func showGroupDetailViewController(group: Group) {
        let postDetailViewController = dependencies.makeGroupDetailViewController(group: group)
        navigationController.pushViewController(postDetailViewController, animated: true)
        navigationController.tabBarController?.tabBar.isHidden = true
    }
    
    func showNotificationViewController() {
        let actions = NotificationViewModelActions() // TODO: 미래에 댓글 눌렀을 때 모임상세화면의 댓글로 이동하는 코드를 위해..
        let notificationViewController = dependencies.makeNotificationViewController(actions: actions)
        navigationController.pushViewController(notificationViewController, animated: true)
    }
}
