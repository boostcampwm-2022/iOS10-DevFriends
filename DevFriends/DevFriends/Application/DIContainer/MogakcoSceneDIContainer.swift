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
        return DefaultPostCommentUseCase(commentRepository: makeGroupCommentRepository())
    }
    
    private func makeSendCommentNotificationUseCase() -> SendCommentNotificationUseCase {
        return DefaultSendCommentNotificationUseCase(notificationRepository: makeNotificationRepository())
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
            fetchUserUseCase: makeLoadUserUseCase(),
            fetchCategoryUseCase: makeLoadCategoryUseCase(),
            fetchCommentsUseCase: makeLoadCommentsUseCase(),
            applyGroupUseCase: makeApplyGroupUseCase(),
            sendGroupApplyNotificationUseCase: makeSendGroupApplyNotificationUseCase(),
            updateLikeUseCase: makeUpdateLikeUseCase(),
            postCommentUseCase: makePostCommentUseCase(),
            sendCommentNotificationUseCase: makeSendCommentNotificationUseCase()
        )
    }
    
    func makePostDetailViewController(actions: PostDetailViewModelActions, group: Group) -> PostDetailViewController {
        return PostDetailViewController(viewModel: makePostDetailViewModel(actions: actions, group: group))
    }
}

extension MogakcoSceneDIContainer: NotificationSceneDIContainer {}
