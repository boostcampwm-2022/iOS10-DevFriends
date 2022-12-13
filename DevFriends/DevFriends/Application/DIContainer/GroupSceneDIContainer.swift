//
//  GroupSceneDIContainer.swift
//  DevFriends
//
//  Created by 이대현 on 2022/11/24.
//

import UIKit

struct GroupSceneDIContainer {
    // MARK: Flow Coordinators
    func makeGroupFlowCoordinator(navigationController: UINavigationController) -> GroupListCoordinator {
        return GroupListCoordinator(navigationController: navigationController, dependencies: self)
    }
}

extension GroupSceneDIContainer: GroupFlowCoordinatorDependencies {
    // MARK: Repositories
    func makeGroupRepository() -> GroupRepository {
        return DefaultGroupRepository()
    }
    
    func makeCategoryRepository() -> CategoryRepository {
        return DefaultCategoryRepository()
    }
    
    func makeUserRepository() -> UserRepository {
        return DefaultUserRepository()
    }
    
    func makeGroupCommentRepository() -> GroupCommentRepository {
        return DefaultGroupCommentRepository()
    }
    
    func makeNotifiactionRepository() -> NotificationRepository {
        return DefaultNotificationRepository()
    }
    
    func makeImageRepository() -> ImageRepository {
        return DefaultImageRepository()
    }
        
    // MARK: UseCases
    func makeFetchGroupUseCase() -> LoadGroupUseCase {
        return DefaultLoadGroupUseCase(groupRepository: makeGroupRepository())
    }
    
    func makeFetchCategoryUseCase() -> LoadCategoryUseCase {
        return DefaultLoadCategoryUseCase(categoryRepository: makeCategoryRepository())
    }
    
    func makeLoadUserUseCase() -> LoadUserUseCase {
        return DefaultLoadUserUseCase(userRepository: makeUserRepository())
    }
    
    func makeLoadCategoryUseCase() -> LoadCategoryUseCase {
        return DefaultLoadCategoryUseCase(categoryRepository: makeCategoryRepository())
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
        return DefaultPostCommentUseCase(
            commentRepository: makeGroupCommentRepository(),
            groupRepository: makeGroupRepository()
        )
    }
    
    func makeSendCommentNotificationUseCase() -> SendCommentNotificationUseCase {
        return DefaultSendCommentNotificationUseCase(notificationRepository: makeNotifiactionRepository())
    }
    
    func makeSortGroupUseCase() -> SortGroupUseCase {
        return DefaultSortGroupUseCase()
    }
    
    func makeLoadProfileImageUseCase() -> LoadProfileImageUseCase {
        return DefaultLoadProfileImageUseCase(imageRepository: makeImageRepository())
    }
    
    func makeUpdateHitUseCase() -> UpdateHitUseCase {
        return DefaultUpdateHitUseCase(groupRepository: makeGroupRepository())
    }
    
    func makeLoadGroupUseCase() -> LoadGroupUseCase {
        return DefaultLoadGroupUseCase(groupRepository: makeGroupRepository())
    }
    
    // MARK: GroupList
    func makeGroupListViewController(actions: GroupListViewModelActions) -> GroupListViewController {
        return GroupListViewController(viewModel: makeGroupListViewModel(actions: actions))
    }
    
    func makeGroupListViewModel(actions: GroupListViewModelActions) -> GroupListViewModel {
        return DefaultGroupListViewModel(
            fetchGroupUseCase: makeFetchGroupUseCase(),
            sortGroupUseCase: makeSortGroupUseCase(),
            fetchCategoryUseCase: makeFetchCategoryUseCase(),
            actions: actions
        )
    }
    
    // MARK: GroupFilterView
    func makeGroupFilterViewController(filter: Filter, actions: GroupFilterViewModelActions) -> GroupFilterViewController {
        let groupFilterViewController = GroupFilterViewController(viewModel: makeGroupFilterViewModel(actions: actions, filter: filter))
        return groupFilterViewController
    }
    
    func makeGroupFilterViewModel(actions: GroupFilterViewModelActions, filter: Filter) -> GroupFilterViewModel {
        return DefaultGroupFilterViewModel(fetchCategoryUseCase: makeFetchCategoryUseCase(), actions: actions, initialFilter: filter)
    }
    
    // MARK: AddGroupScene
    func makeAddGroupSceneDIContainer() -> AddGroupSceneDIContainer {
        return AddGroupSceneDIContainer()
    }
    
    
    // MARK: PostDetailScene
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
}

extension GroupSceneDIContainer: NotificationSceneDIContainer {}
