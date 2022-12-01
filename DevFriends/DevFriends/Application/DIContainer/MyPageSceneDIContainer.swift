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
    
    func makeFetchProfileImageUseCase() -> FetchProfileImageUseCase {
        return DefaultFetchProfileImageUseCase(imageRepository: makeImageRepository())
    }
    
    // MARK: MyPageViwe
    func makeMyPageViewModel(actions: MyPageViewModelActions) -> MyPageViewModel {
        return MyPageViewModel(actions: actions)
    }
    
    func makeMyPageViewController(actions: MyPageViewModelActions) -> MyPageViewController {
        return MyPageViewController(viewModel: makeMyPageViewModel(actions: actions))
    }
    
    // MARK: MyGroupsView
    func makeMyGroupsViewModel(type: MyGroupsType) -> MyGroupsViewModel {
        return MyGroupsViewModel(type: type)
    }
    
    func makeMakedGroupViewController() -> MyGroupsViewController {
        return MyGroupsViewController(viewModel: makeMyGroupsViewModel(type: .makedGroup))
    }
    
    // MARK: ParticipatedGroupVIew
    func makeParticipatedGroupViewController() -> MyGroupsViewController {
        return MyGroupsViewController(viewModel: makeMyGroupsViewModel(type: .participatedGroup))
    }
    
    // MARK: LikedGroupView
    func makeLikedGroupViewController() -> MyGroupsViewController {
        return MyGroupsViewController(viewModel: makeMyGroupsViewModel(type: .likedGroup))
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
            fetchProfileImageUseCase: makeFetchProfileImageUseCase()
        )
    }
    
    func makeFixMyInfoViewController(actions: FixMyInfoViewModelActions) -> FixMyInfoViewController {
        return FixMyInfoViewController(viewModel: makeFixMyInfoViewModel(actions: actions))
    }
}
