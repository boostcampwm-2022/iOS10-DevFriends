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
        return MyPageCoordinator(navigationController: navigationController, dependencies: self)
    }
}

extension MyPageSceneDIContainer: MyPageFlowCoordinatorDependencies {
    // MARK: Repository
    func makeUserRepository() -> UserRepository {
        return DefaultUserRepository()
    }
    
    func makeImageRepository() -> ImageRepository {
        return DefaultImageRepository()
    }
    
    // MARK: UseCase
    func makeUploadProfileImageUseCase() -> UploadProfileImageUseCase {
        return DefaultUploadProfileImageUseCase(imageRepository: makeImageRepository())
    }
    
    func makeUpdateUserInfoUseCase() -> UpdateUserInfoUseCase {
        return DefaultUpdateUserInfoUseCase(userRepository: makeUserRepository())
    }
    
    func makeLoadProfileImageUseCase() -> LoadProfileImageUseCase {
        return DefaultLoadProfileImageUseCase(imageRepository: makeImageRepository())
    }
    
    // MARK: MyPageViwe
    func makeMyPageViewModel(actions: MyPageViewModelActions) -> MyPageViewModel {
        return MyPageViewModel(actions: actions)
    }
    
    func makeMyPageViewController(actions: MyPageViewModelActions) -> MyPageViewController {
        return MyPageViewController(viewModel: makeMyPageViewModel(actions: actions))
    }
    
    // MARK: MyGroupsView
    func makeMyGroupsViewModel(type: MyGroupsType, actions: MyGroupsViewModelActions) -> MyGroupsViewModel {
        return MyGroupsViewModel(type: type, actions: actions)
    }
    
    func makeMakedGroupViewController(actions: MyGroupsViewModelActions) -> MyGroupsViewController {
        return MyGroupsViewController(viewModel: makeMyGroupsViewModel(type: .makedGroup, actions: actions))
    }
    
    // MARK: ParticipatedGroupVIew
    func makeParticipatedGroupViewController(actions: MyGroupsViewModelActions) -> MyGroupsViewController {
        return MyGroupsViewController(viewModel: makeMyGroupsViewModel(type: .participatedGroup, actions: actions))
    }
    
    // MARK: LikedGroupView
    func makeLikedGroupViewController(actions: MyGroupsViewModelActions) -> MyGroupsViewController {
        return MyGroupsViewController(viewModel: makeMyGroupsViewModel(type: .likedGroup, actions: actions))
    }
    
    // MARK: PopUpView
    func makePopupViewController(popup: Popup) -> PopupViewController {
        let popupViewController = PopupViewController()
        popupViewController.set(popup: popup)
        return popupViewController
    }
    
    // MARK: FixMyInfoView
    private func makeFixMyInfoViewModel(actions: FixMyInfoViewModelActions) -> FixMyInfoViewModel {
        return DefaultFixMyInfoViewModel(
            actions: actions,
            updateUserInfoUseCase: makeUpdateUserInfoUseCase(),
            uploadProfileImageUseCase: makeUploadProfileImageUseCase(),
            fetchProfileImageUseCase: makeLoadProfileImageUseCase()
        )
    }
    
    func makeFixMyInfoViewController(actions: FixMyInfoViewModelActions) -> FixMyInfoViewController {
        return FixMyInfoViewController(viewModel: makeFixMyInfoViewModel(actions: actions))
    }
}
