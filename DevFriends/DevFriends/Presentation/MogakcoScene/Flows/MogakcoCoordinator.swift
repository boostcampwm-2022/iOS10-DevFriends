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
    func makePostDetailViewController(actions: PostDetailViewModelActions, group: Group) -> PostDetailViewController
    func makeNotificationViewController(actions: NotificationViewModelActions) -> NotificationViewController
    func makeAddGroupSceneDIContainer() -> AddGroupSceneDIContainer
    func makePostReportViewController(actions: PostReportViewControllerActions) -> PostReportViewController
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
            showGroupDetail: showGroupDetailViewController,
            showNotifications: showNotificationViewController,
            showAddMogakcoScene: startAddMogakcoScene
        )
        let mogakcoViewController = dependencies.makeMogakcoViewController(actions: actions)
        navigationController.navigationBar.topItem?.title = "모각코"
        navigationController.pushViewController(mogakcoViewController, animated: false)
    }
}

extension MogakcoCoordinator {
    func showGroupDetailViewController(group: Group) {
        let actions = PostDetailViewModelActions(
            backToPrevViewController: moveBackToMogakcoViewController,
            report: showPostReportViewController
        )
        let postDetailViewController = dependencies.makePostDetailViewController(actions: actions, group: group)
        navigationController.pushViewController(postDetailViewController, animated: true)
        navigationController.tabBarController?.tabBar.isHidden = true
    }
    
    func startAddMogakcoScene() {
        let addGroupDIContainer = dependencies.makeAddGroupSceneDIContainer()
        let flow = addGroupDIContainer.makeAddGroupFlowCoordinator(
            navigationController: self.navigationController,
            groupType: .mogakco
        )
        flow.start()
        childCoordinators.append(flow)
    }
    
    func showNotificationViewController() {
        let actions = NotificationViewModelActions(moveBackToPrevViewController: moveBackToMogakcoViewController) // TODO: 미래에 댓글 눌렀을 때 모임상세화면의 댓글로 이동하는 코드를 위해..
        let notificationViewController = dependencies.makeNotificationViewController(actions: actions)
        navigationController.pushViewController(notificationViewController, animated: true)
        navigationController.tabBarController?.tabBar.isHidden = true
    }
}

extension MogakcoCoordinator {
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
        mogakcoViewController.setNowMogakcoWithAllList(index: index)
        mogakcoViewController.presentedViewController?.dismiss(animated: true)
    }
    
    func moveBackToMogakcoViewController() {
        navigationController.tabBarController?.tabBar.isHidden = false
        navigationController.popViewController(animated: true)
    }
    
    func showPostReportViewController() {
        let actions = PostReportViewControllerActions(
            submit: moveBackToMogakcoViewController,
            close: moveBackToMogakcoViewController
        )
        let reportViewController = dependencies.makePostReportViewController(actions: actions)
        navigationController.pushViewController(reportViewController, animated: true)
    }
}
