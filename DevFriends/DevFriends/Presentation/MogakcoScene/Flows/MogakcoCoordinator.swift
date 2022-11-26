//
//  MogakcoCoordinator.swift
//  DevFriends
//
//  Created by 상현 on 2022/11/24.
//

import UIKit

protocol MogakcoCoordinatorDependencies {
    func makeMogakcoViewController(actions: MogakcoViewModelActions) -> MogakcoViewController
    func makeMogakcoModalViewController(actions: MogakcoModalViewActions, mogakcos: [Group]) -> MogakcoModalViewController
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
        let actions = MogakcoViewModelActions(
            showMogakcoModal: showMogakcoModal,
            showGroupDetail: showGroupDetailViewController
        )
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

extension MogakcoCoordinator: MogakcoModalCoordinator {
    func showMogakcoModal(mogakcos: [Group]) {
        let actions = MogakcoModalViewActions(didSelectMogakcoCell: selectMogakco)
        let modalViewController = dependencies.makeMogakcoModalViewController(actions: actions, mogakcos: mogakcos)
        modalViewController.modalPresentationStyle = .pageSheet
        if let sheet = modalViewController.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
            sheet.largestUndimmedDetentIdentifier = .medium
        }
        navigationController.present(modalViewController, animated: true, completion: nil)
    }
    
    func selectMogakco(index: Int) {
        guard let mogakcoViewController = navigationController.viewControllers.last as? MogakcoViewController else {
            return
        }
        mogakcoViewController.showMogakcoCollectionView()
        mogakcoViewController.setNowMogackoWithAllList(index: index)
    }
}
