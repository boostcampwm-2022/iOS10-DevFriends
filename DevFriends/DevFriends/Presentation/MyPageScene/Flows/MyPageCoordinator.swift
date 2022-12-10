//
//  MyPageCoordinator.swift
//  DevFriends
//
//  Created by 심주미 on 2022/11/24.
//

import UIKit

protocol MyPageFlowCoordinatorDependencies {
    func makeMyPageViewController(actions: MyPageViewModelActions) -> MyPageViewController
    func makeMakedGroupViewController(actions: MyGroupsViewModelActions) -> MyGroupsViewController
    func makeParticipatedGroupViewController(actions: MyGroupsViewModelActions) -> MyGroupsViewController
    func makeLikedGroupViewController(actions: MyGroupsViewModelActions) -> MyGroupsViewController
    func makePostDetailViewController(actions: PostDetailViewModelActions, group: Group) -> PostDetailViewController
    func makePopupViewController(popup: Popup) -> PopupViewController
    func makeFixMyInfoViewController(userInfo: FixMyInfoStruct, actions: FixMyInfoViewModelActions) -> FixMyInfoViewController
    func makeCategoryViewController(actions: ChooseCategoryViewModelActions, initFilter: [Category]?) -> ChooseCategoryViewController
    func makePostReportViewController(actions: PostReportViewControllerActions) -> PostReportViewController
}

protocol MyPageCoordinatorDelegate: AnyObject {
    func showLoginView()
}

final class MyPageCoordinator: Coordinator {
    private weak var navigationController: UINavigationController?
    let dependencies: MyPageFlowCoordinatorDependencies
    weak var delegate: MyPageCoordinatorDelegate?
    
    init(navigationController: UINavigationController, dependencies: MyPageFlowCoordinatorDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        let actions = MyPageViewModelActions(
            showMakedGroup: showMakedGroupViewController,
            showParticipatedGroup: showParticipatedGroupViewController,
            showLikedGroup: showLikedGroupViewController,
            showFixMyInfo: showFixMyInfoViewController,
            showPopup: showPopupViewController,
            showLoginView: showLoginViewController
        )
        let myPageViewController = dependencies.makeMyPageViewController(actions: actions)
        navigationController?.pushViewController(myPageViewController, animated: false)
    }
    
    func showMakedGroupViewController() {
        let actions = MyGroupsViewModelActions(back: popViewController, showPostDetailScene: showGroupDetailViewController)
        let groupViewController = dependencies.makeMakedGroupViewController(actions: actions)
        navigationController?.pushViewController(groupViewController, animated: true)
        navigationController?.tabBarController?.tabBar.isHidden = true
    }
    
    func showParticipatedGroupViewController() {
        let actions = MyGroupsViewModelActions(back: popViewController, showPostDetailScene: showGroupDetailViewController)
        let groupViewController = dependencies.makeParticipatedGroupViewController(actions: actions)
        navigationController?.pushViewController(groupViewController, animated: true)
        navigationController?.tabBarController?.tabBar.isHidden = true
    }
    
    func showLikedGroupViewController() {
        let actions = MyGroupsViewModelActions(back: popViewController, showPostDetailScene: showGroupDetailViewController)
        let groupViewController = dependencies.makeLikedGroupViewController(actions: actions)
        navigationController?.pushViewController(groupViewController, animated: true)
        navigationController?.tabBarController?.tabBar.isHidden = true
    }
    
    func showGroupDetailViewController(group: Group) {
        let actions = PostDetailViewModelActions(
            backToPrevViewController: moveBackToGroupListViewController,
            report: showPostReportViewController
        )
        let postDetailViewController = dependencies.makePostDetailViewController(actions: actions, group: group)
        navigationController?.pushViewController(postDetailViewController, animated: true)
        navigationController?.tabBarController?.tabBar.isHidden = true
    }
    
    func moveBackToGroupListViewController() {
        navigationController?.popViewController(animated: true)
    }
    
    func showFixMyInfoViewController(userInfo: FixMyInfoStruct) {
        let actions = FixMyInfoViewModelActions(
            showCategoryChoice: showCategoryViewController,
            didSubmitFixInfo: didSubmitFixInfo,
            popFixMyInfo: popViewController
        )
        let fixMyInfoViewController = dependencies.makeFixMyInfoViewController(userInfo: userInfo, actions: actions)
        navigationController?.pushViewController(fixMyInfoViewController, animated: true)
        navigationController?.tabBarController?.tabBar.isHidden = true
    }
    
    func showPopupViewController(popup: Popup) {
        let popupViewController = dependencies.makePopupViewController(popup: popup)
        popupViewController.modalPresentationStyle = .overFullScreen
        navigationController?.present(popupViewController, animated: false)
    }
    
    func showLoginViewController() {
        delegate?.showLoginView()
    }
    
    func showPostReportViewController() {
        let acitons = PostReportViewControllerActions(
            submit: popViewControllerWithHiddenTabBar,
            close: popViewControllerWithHiddenTabBar
        )
        let postReportViewController = dependencies.makePostReportViewController(actions: acitons)
        navigationController?.pushViewController(postReportViewController, animated: true)
    }
    
    func popViewControllerWithHiddenTabBar() {
        navigationController?.popViewController(animated: true)
        navigationController?.tabBarController?.tabBar.isHidden = true
    }
}

extension MyPageCoordinator {
    func showCategoryViewController(categories: [Category]?) {
        let actions = ChooseCategoryViewModelActions(didSubmitCategory: didSubmitCategorySelection)
        let categoryViewController = dependencies.makeCategoryViewController(actions: actions, initFilter: categories)
        navigationController?.pushViewController(categoryViewController, animated: true)
    }
    
    func didSubmitCategorySelection(updatedCategories: [Category]) {
        navigationController?.popViewController(animated: true)
        guard let viewController = navigationController?.viewControllers.last as? FixMyInfoViewController else { return }
        viewController.updateCategories(categories: updatedCategories)
    }
    
    func didSubmitFixInfo(nickname: String, image: UIImage?, categories: [Category]) {
        popViewController()
        
        guard let viewController = navigationController?.viewControllers.last as? MyPageViewController else { return }
        viewController.updateUserInfo(nickname: nickname, image: image, categories: categories)
    }
    
    func popViewController() {
        navigationController?.popViewController(animated: true)
        navigationController?.tabBarController?.tabBar.isHidden = false
    }
}
