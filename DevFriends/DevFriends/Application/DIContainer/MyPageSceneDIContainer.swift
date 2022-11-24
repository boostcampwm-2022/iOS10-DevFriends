//
//  MyPageSceneDIContainer.swift
//  DevFriends
//
//  Created by 심주미 on 2022/11/24.
//

import Foundation
import UIKit

struct MyPageSceneDIContainer {
    func makeMyPageCoordinator(navigationController: UINavigationController) -> MyPageCoordinator {
        return MyPageCoordinator(navigationController: navigationController,
                                 dependencies: self)
    }
}

extension MyPageSceneDIContainer: MyPageFlowCoordinatorDependencies {
    func makeMyPageViewModel(actions: MyPageViewModelActions) -> MyPageViewModel {
        return MyPageViewModel(actions: actions)
    }
    
    func makeMyPageViewController(actions: MyPageViewModelActions) -> MyPageViewController {
        return MyPageViewController(viewModel: makeMyPageViewModel(actions: actions))
    }
    
    func makeMyGroupsViewModel(type: MyGroupsType) -> MyGroupsViewModel {
        return MyGroupsViewModel(type: type)
    }
    
    func makeMakedGroupViewController() -> MyGroupsViewController {
        return MyGroupsViewController(viewModel: makeMyGroupsViewModel(type: .makedGroup))
    }
    
    func makeParticipatedGroupViewController() -> MyGroupsViewController {
        return MyGroupsViewController(viewModel: makeMyGroupsViewModel(type: .participatedGroup))
    }
    
    func makeLikedGroupViewController() -> MyGroupsViewController {
        return MyGroupsViewController(viewModel: makeMyGroupsViewModel(type: .likedGroup))
    }
    
    func makePopupViewController(popup: Popup) -> PopupViewController {
        let popupViewController = PopupViewController()
        popupViewController.set(popup: popup)
        return popupViewController
    }
    
    func makeFixMyInfoViewController() -> FixMyInfoViewController {
        return FixMyInfoViewController()
    }
}
