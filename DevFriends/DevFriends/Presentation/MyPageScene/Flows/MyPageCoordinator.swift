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
    func makePopupViewController(popup: Popup) -> PopupViewController
    func makeFixMyInfoViewController(actions: FixMyInfoViewModelActions) -> FixMyInfoViewController
}

final class MyPageCoordinator: Coordinator {
    private weak var navigationController: UINavigationController?
    let dependencies: MyPageFlowCoordinatorDependencies
    
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
            showPopup: showPopupViewController
        )
        let myPageViewController = dependencies.makeMyPageViewController(actions: actions)
        navigationController?.pushViewController(myPageViewController, animated: false)
    }
    
    func showMakedGroupViewController() {
        let actions = MyGroupsViewModelActions(back: popViewController)
        let groupViewController = dependencies.makeMakedGroupViewController(actions: actions)
        navigationController?.pushViewController(groupViewController, animated: true)
        navigationController?.tabBarController?.tabBar.isHidden = true
    }
    
    func showParticipatedGroupViewController() {
        let actions = MyGroupsViewModelActions(back: popViewController)
        let groupViewController = dependencies.makeParticipatedGroupViewController(actions: actions)
        navigationController?.pushViewController(groupViewController, animated: true)
        navigationController?.tabBarController?.tabBar.isHidden = true
    }
    
    func showLikedGroupViewController() {
        let actions = MyGroupsViewModelActions(back: popViewController)
        let groupViewController = dependencies.makeLikedGroupViewController(actions: actions)
        navigationController?.pushViewController(groupViewController, animated: true)
        navigationController?.tabBarController?.tabBar.isHidden = true
    }
    
    func showFixMyInfoViewController() {
        let actions = FixMyInfoViewModelActions(showCategoryChoice: showCategoryChoice, popFixMyInfo: popViewController)
        let fixMyInfoViewController = dependencies.makeFixMyInfoViewController(actions: actions)
        navigationController?.pushViewController(fixMyInfoViewController, animated: true)
        navigationController?.tabBarController?.tabBar.isHidden = true
    }
    
    func showPopupViewController(popup: Popup) {
        let popupViewController = dependencies.makePopupViewController(popup: popup)
        popupViewController.modalPresentationStyle = .overFullScreen
        navigationController?.present(popupViewController, animated: false)
    }
}

extension MyPageCoordinator {
    func showCategoryChoice() { }
    
    func popViewController() {
        navigationController?.popViewController(animated: true)
        navigationController?.tabBarController?.tabBar.isHidden = false
    }
}
