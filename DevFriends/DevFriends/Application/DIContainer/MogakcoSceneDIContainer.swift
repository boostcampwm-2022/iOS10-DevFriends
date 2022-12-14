//
//  MogakcoSceneDIContainer.swift
//  DevFriends
//
//  Created by 상현 on 2022/11/24.
//

import UIKit

struct MogakcoSceneDIContainer {
    // MARK: Flow Coordinators
    func makeMogakcoFlowCoordinator(navigationController: UINavigationController) -> MogakcoCoordinator {
        return MogakcoCoordinator(navigationController: navigationController, dependencies: self)
    }
}

extension MogakcoSceneDIContainer: MogakcoCoordinatorDependencies {
    // MARK: Repositories
    private func makeGroupRepository() -> GroupRepository {
        return DefaultGroupRepository()
    }
    
    private func makeUserRepository() -> UserRepository {
        return DefaultUserRepository()
    }
    
    private func makeCategoryRepository() -> CategoryRepository {
        return DefaultCategoryRepository()
    }
    
    private func makeGroupCommentRepository() -> GroupCommentRepository {
        return DefaultGroupCommentRepository()
    }
    
    private func makeNotificationRepository() -> NotificationRepository {
        return DefaultNotificationRepository()
    }
    
    private func makeImageRepository() -> ImageRepository {
        return DefaultImageRepository()
    }

    // MARK: UseCases
    private func makeLoadGroupUseCase() -> LoadGroupUseCase {
        return DefaultLoadGroupUseCase(groupRepository: makeGroupRepository())
    }
    
    private func makeLoadUserUseCase() -> LoadUserUseCase {
        return DefaultLoadUserUseCase(userRepository: makeUserRepository())
    }
    
    private func makeLoadCategoryUseCase() -> LoadCategoryUseCase {
        return DefaultLoadCategoryUseCase(categoryRepository: makeCategoryRepository())
    }
    
    private func makeLoadCommentsUseCase() -> LoadCommentsUseCase {
        return DefaultLoadCommentsUseCase(commentRepository: makeGroupCommentRepository())
    }
    
    private func makeUpdateLikeUseCase() -> UpdateLikeUseCase {
        return DefaultUpdateLikeUseCase(userRepository: makeUserRepository(), groupRepository: makeGroupRepository())
    }
    
    private func makeApplyGroupUseCase() -> ApplyGroupUseCase {
        return DefaultApplyGroupUseCase(userRepository: makeUserRepository())
    }
    
    private func makeSendGroupApplyNotificationUseCase() -> SendGroupApplyNotificationUseCase {
        return DefaultSendGroupApplyNotificationUseCase(notificationRepository: makeNotificationRepository())
    }
    
    private func makePostCommentUseCase() -> PostCommentUseCase {
        return DefaultPostCommentUseCase(commentRepository: makeGroupCommentRepository(), groupRepository: makeGroupRepository())
    }
    
    private func makeSendCommentNotificationUseCase() -> SendCommentNotificationUseCase {
        return DefaultSendCommentNotificationUseCase(notificationRepository: makeNotificationRepository())
    }
    
    private func makeLoadProfileImageUseCase() -> LoadProfileImageUseCase {
        return DefaultLoadProfileImageUseCase(imageRepository: makeImageRepository())
    }
    
    private func makeUpdateHitUseCase() -> UpdateHitUseCase {
        return DefaultUpdateHitUseCase(groupRepository: makeGroupRepository())
    }
    
    // MARK: Mogakco
    private func makeMogakcoViewModel(actions: MogakcoViewModelActions) -> MogakcoViewModel {
        return MogakcoViewModel(fetchGroupUseCase: makeLoadGroupUseCase(), actions: actions)
    }
    
    func makeMogakcoViewController(actions: MogakcoViewModelActions) -> MogakcoViewController {
        return MogakcoViewController(viewModel: makeMogakcoViewModel(actions: actions))
    }
    
    func makeMogakcoModalViewController(actions: MogakcoModalViewActions, mogakcos: [Group]) -> MogakcoModalViewController {
        let mogakcoModalViewController = MogakcoModalViewController(actions: actions)
        mogakcoModalViewController.populateSnapshot(data: mogakcos)
        
        return mogakcoModalViewController
    }
    
    // MARK: PostDetail
    private func makePostDetailViewModel(actions: PostDetailViewModelActions, group: Group) -> PostDetailViewModel {
        return DefaultPostDetailViewModel(
            actions: actions,
            group: group,
            fetchGroupUseCase: makeLoadGroupUseCase(),
            fetchUserUseCase: makeLoadUserUseCase(),
            fetchCategoryUseCase: makeLoadCategoryUseCase(),
            fetchCommentsUseCase: makeLoadCommentsUseCase(),
            applyGroupUseCase: makeApplyGroupUseCase(),
            sendGroupApplyNotificationUseCase: makeSendGroupApplyNotificationUseCase(),
            updateLikeUseCase: makeUpdateLikeUseCase(),
            postCommentUseCase: makePostCommentUseCase(),
            sendCommentNotificationUseCase: makeSendCommentNotificationUseCase(),
            loadProfileImageUseCase: makeLoadProfileImageUseCase(),
            updateHitUseCase: makeUpdateHitUseCase()
        )
    }
    
    func makePostDetailViewController(actions: PostDetailViewModelActions, group: Group) -> PostDetailViewController {
        return PostDetailViewController(viewModel: makePostDetailViewModel(actions: actions, group: group))
    }
    
    func makePostReportViewController(actions: PostReportViewControllerActions) -> PostReportViewController {
        return PostReportViewController(actions: actions)
    }
    
    // MARK: AddGroupScene
    func makeAddGroupSceneDIContainer() -> AddGroupSceneDIContainer {
        return AddGroupSceneDIContainer()
    }
}

extension MogakcoSceneDIContainer: NotificationSceneDIContainer {}
