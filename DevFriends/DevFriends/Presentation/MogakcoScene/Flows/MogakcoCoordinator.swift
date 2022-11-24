//
//  MogakcoCoordinator.swift
//  DevFriends
//
//  Created by 상현 on 2022/11/24.
//

import UIKit

protocol MogakcoCoordinatorDependencies {
    func makeMogakcoViewController(actions: MogakcoViewModelActions) -> MogakcoViewController
    func makeGroupDetailViewController(group: Group) -> PostDetailViewController
}

final class MogakcoCoordinator: Coordinator {
    let navigationController: UINavigationController
    let dependencies: MogakcoCoordinatorDependencies

    var childCoordinators: [Coordinator] = []
    
    init(
        navigationController: UINavigationController,
        dependencies: MogakcoCoordinatorDependencies
    ) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        let actions = MogakcoViewModelActions(showGroupDetail: showGroupDetailViewController)
        let mogakcoViewController = dependencies.makeMogakcoViewController(actions: actions)
        navigationController.pushViewController(mogakcoViewController, animated: false)
    }
}

extension MogakcoCoordinator: GroupDetailCoordinator {
    func showGroupDetailViewController(group: Group) {
        let postDetailViewController = dependencies.makeGroupDetailViewController(group: group)
        navigationController.pushViewController(postDetailViewController, animated: true)
    }
}
