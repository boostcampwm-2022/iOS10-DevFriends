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
    private func makeFetchGroupUseCase() -> FetchGroupUseCase {
        return DefaultFetchGroupUseCase(groupRepository: makeGroupRepository())
    }
    
    private func makeFetchUserUseCase() -> FetchUserUseCase {
        return DefaultFetchUserUseCase(userRepository: makeUserRepository())
    }
    
    private func makeFetchCategoryUseCase() -> FetchCategoryUseCase {
        return DefaultFetchCategoryUseCase(categoryRepository: makeCategoryRepository())
    }
    
    private func makeFetchCommentsUseCase() -> FetchCommentsUseCase {
        return DefaultFetchCommentsUseCase(commentRepository: makeGroupCommentRepository())
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
        return MogakcoViewModel(fetchGroupUseCase: makeFetchGroupUseCase(), actions: actions)
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
    private func makePostDetailViewModel(group: Group) -> PostDetailViewModel {
        return DefaultPostDetailViewModel(
            group: group,
            fetchUserUseCase: makeFetchUserUseCase(),
            fetchCategoryUseCase: makeFetchCategoryUseCase(),
            fetchCommentsUseCase: makeFetchCommentsUseCase(),
            applyGroupUseCase: makeApplyGroupUseCase(),
            sendGroupApplyNotificationUseCase: makeSendGroupApplyNotificationUseCase(),
            postCommentUseCase: makePostCommentUseCase(),
            sendCommentNotificationUseCase: makeSendCommentNotificationUseCase()
        )
    }
    
    func makeGroupDetailViewController(group: Group) -> PostDetailViewController {
        return PostDetailViewController(viewModel: makePostDetailViewModel(group: group))
    }
}

extension MogakcoSceneDIContainer: NotificationSceneDIContainer {}
