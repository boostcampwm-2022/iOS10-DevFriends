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
    
    func makeCategoryRepository() -> CategoryRepository {
        return DefaultCategoryRepository()
    }
    
    func makeGroupRepository() -> GroupRepository {
        return DefaultGroupRepository()
    }

    func makeGroupCommentRepository() -> GroupCommentRepository {
        return DefaultGroupCommentRepository()
    }

    func makeNotifiactionRepository() -> NotificationRepository {
        return DefaultNotificationRepository()
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
    
    func makeLoadCategoryUseCase() -> LoadCategoryUseCase {
        return DefaultLoadCategoryUseCase(categoryRepository: makeCategoryRepository())
    }
    
    func makeLoadGroupUseCase() -> LoadGroupUseCase {
        return DefaultLoadGroupUseCase(groupRepository: makeGroupRepository())
    }
    
    func makeLoadUserUseCase() -> LoadUserUseCase {
        return DefaultLoadUserUseCase(userRepository: makeUserRepository())
    }

    func makeLoadCommentsUseCase() -> LoadCommentsUseCase {
        return DefaultLoadCommentsUseCase(commentRepository: makeGroupCommentRepository())
    }

    func makeApplyGroupUseCase() -> ApplyGroupUseCase {
        return DefaultApplyGroupUseCase(userRepository: makeUserRepository())
    }

    func makeSendGroupApplyNotificationUseCase() -> SendGroupApplyNotificationUseCase {
        return DefaultSendGroupApplyNotificationUseCase(notificationRepository: makeNotifiactionRepository())
    }

    func makeUpdateLikeUseCase() -> UpdateLikeUseCase {
        return DefaultUpdateLikeUseCase(
            userRepository: makeUserRepository(),
            groupRepository: makeGroupRepository()
        )
    }
    func makePostCommentUseCase() -> PostCommentUseCase {
        return DefaultPostCommentUseCase(commentRepository: makeGroupCommentRepository())
    }

    func makeSendCommentNotificationUseCase() -> SendCommentNotificationUseCase {
        return DefaultSendCommentNotificationUseCase(notificationRepository: makeNotifiactionRepository())
    }
    
    func makeLoadUserGroupIDsUseCase() -> LoadUserGroupIDsUseCase {
        return DefaultLoadUserGroupIDsUseCase(userRepository: makeUserRepository())
    }
    
    func makeLeaveGroupUseCase() -> LeaveGroupUseCase {
        return DefaultLeaveGroupUseCase(userRepository: makeUserRepository(), groupRepository: makeGroupRepository())
    }
    
    // MARK: MyPageViwe
    func makeMyPageViewModel(actions: MyPageViewModelActions) -> MyPageViewModel {
        return DefaultMyPageViewModel(actions: actions, loadCategoryUseCase: makeLoadCategoryUseCase())
    }
    
    func makeMyPageViewController(actions: MyPageViewModelActions) -> MyPageViewController {
        return MyPageViewController(viewModel: makeMyPageViewModel(actions: actions))
    }
    
    // MARK: MyGroupsView
    func makeMyGroupsViewModel(type: MyGroupsType, actions: MyGroupsViewModelActions) -> MyGroupsViewModel {
        return DefaultMyGroupsViewModel(
            type: type,
            actions: actions,
            loadUserGroupIDsUseCase: makeLoadUserGroupIDsUseCase(),
            loadGroupUseCase: makeLoadGroupUseCase(),
            leaveGroupUseCase: makeLeaveGroupUseCase()
        )
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
    
    // MARK: PostDetailView
    private func makePostDetailViewModel(actions: PostDetailViewModelActions, group: Group) -> PostDetailViewModel {
        return DefaultPostDetailViewModel(
            actions: actions,
            group: group,
            fetchUserUseCase: makeLoadUserUseCase(),
            fetchCategoryUseCase: makeLoadCategoryUseCase(),
            fetchCommentsUseCase: makeLoadCommentsUseCase(),
            applyGroupUseCase: makeApplyGroupUseCase(),
            sendGroupApplyNotificationUseCase: makeSendGroupApplyNotificationUseCase(),
            updateLikeUseCase: makeUpdateLikeUseCase(),
            postCommentUseCase: makePostCommentUseCase(),
            sendCommentNotificationUseCase: makeSendCommentNotificationUseCase(),
            loadProfileImageUseCase: makeLoadProfileImageUseCase()
        )
    }

    func makePostDetailViewController(actions: PostDetailViewModelActions, group: Group) -> PostDetailViewController {
        return PostDetailViewController(viewModel: makePostDetailViewModel(actions: actions, group: group))
    }
    
    // MARK: PopUpView
    func makePopupViewController(popup: Popup) -> PopupViewController {
        let popupViewController = PopupViewController()
        popupViewController.set(popup: popup)
        return popupViewController
    }
    
    // MARK: FixMyInfoView
    private func makeFixMyInfoViewModel(userInfo: FixMyInfoStruct, actions: FixMyInfoViewModelActions) -> FixMyInfoViewModel {
        return DefaultFixMyInfoViewModel(
            userInfo: userInfo,
            actions: actions,
            updateUserInfoUseCase: makeUpdateUserInfoUseCase(),
            uploadProfileImageUseCase: makeUploadProfileImageUseCase(),
            fetchProfileImageUseCase: makeLoadProfileImageUseCase(),
            loadCategoryUseCase: makeLoadCategoryUseCase()
        )
    }
    
    func makeFixMyInfoViewController(userInfo: FixMyInfoStruct, actions: FixMyInfoViewModelActions) -> FixMyInfoViewController {
        return FixMyInfoViewController(viewModel: makeFixMyInfoViewModel(userInfo: userInfo, actions: actions))
    }
    
    // MARK: ChooseCategoryView
    private func makeChooseCategoryViewModel(actions: ChooseCategoryViewModelActions) -> ChooseCategoryViewModel {
        return DefaultChooseCategoryViewModel(
            fetchCategoryUseCase: makeLoadCategoryUseCase(),
            actions: actions
        )
    }
    
    func makeCategoryViewController(actions: ChooseCategoryViewModelActions) -> ChooseCategoryViewController {
        return ChooseCategoryViewController(viewModel: makeChooseCategoryViewModel(actions: actions))
    }
    
    func makePostReportViewController(actions: PostReportViewControllerActions) -> PostReportViewController {
        return PostReportViewController(actions: actions)
    }
}
