//
//  NotificationCoordinator.swift
//  DevFriends
//
//  Created by 유승원 on 2022/11/24.
//

import UIKit

protocol NotificationCoordinatorDependencies {
    func makeNotificationViewController(actions: NotificationViewModelActions) -> NotificationViewController
}

final class NotificationCoordinator: Coordinator {
    private let dependencies: NotificationCoordinatorDependencies
    let navigationController: UINavigationController
    
    init(navigationController: UINavigationController, dependencies: NotificationCoordinatorDependencies) {
        self.dependencies = dependencies
        self.navigationController = navigationController
    }
    
    func start() {
        let actions = NotificationViewModelActions()
        let notificationViewController = dependencies.makeNotificationViewController(actions: actions)
        navigationController.pushViewController(notificationViewController, animated: false)
        navigationController.tabBarController?.tabBar.isHidden = true
    }
}
