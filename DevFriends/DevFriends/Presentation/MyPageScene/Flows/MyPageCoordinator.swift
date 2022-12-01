//
//  MyPageCoordinator.swift
//  DevFriends
//
//  Created by 심주미 on 2022/11/24.
//

import UIKit

protocol MyPageFlowCoordinatorDependencies {
    func makeMyPageViewController(actions: MyPageViewModelActions) -> MyPageViewController
    func makeMakedGroupViewController() -> MyGroupsViewController
    func makeParticipatedGroupViewController() -> MyGroupsViewController
    func makeLikedGroupViewController() -> MyGroupsViewController
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
        let groupViewController = dependencies.makeMakedGroupViewController()
        navigationController?.pushViewController(groupViewController, animated: true)
    }
    
    func showParticipatedGroupViewController() {
        let groupViewController = dependencies.makeParticipatedGroupViewController()
        navigationController?.pushViewController(groupViewController, animated: true)
    }
    
    func showLikedGroupViewController() {
        let groupViewController = dependencies.makeLikedGroupViewController()
        navigationController?.pushViewController(groupViewController, animated: true)
    }
    
    func showFixMyInfoViewController() {
        let actions = FixMyInfoViewModelActions(showCategoryChoice: showCategoryChoice, popFixMyInfo: popFixMyInfo)
        let fixMyInfoViewController = dependencies.makeFixMyInfoViewController(actions: actions)
        navigationController?.pushViewController(fixMyInfoViewController, animated: true)
    }
    
    func showPopupViewController(popup: Popup) {
        let popupViewController = dependencies.makePopupViewController(popup: popup)
        popupViewController.modalPresentationStyle = .overFullScreen
        navigationController?.present(popupViewController, animated: false)
    }
}

extension MyPageCoordinator {
    func showCategoryChoice() { }
    
    func popFixMyInfo() {
        navigationController?.popViewController(animated: true)
    }
}
