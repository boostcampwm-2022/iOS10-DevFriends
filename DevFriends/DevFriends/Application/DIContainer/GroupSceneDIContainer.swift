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
    
    // MARK: UseCases
    func makeFetchGroupUseCase() -> FetchGroupUseCase {
        return DefaultFetchGroupUseCase(groupRepository: makeGroupRepository())
    }
    
    func makeFetchCategoryUseCase() -> FetchCategoryUseCase {
        return DefaultFetchCategoryUseCase(categoryRepository: makeCategoryRepository())
    }
    
    // MARK: GroupList
    func makeGroupListViewController(actions: GroupListViewModelActions) -> GroupListViewController {
        return GroupListViewController(viewModel: makeGroupListViewModel(actions: actions))
    }
    
    func makeGroupListViewModel(actions: GroupListViewModelActions) -> GroupListViewModel {
        return DefaultGroupListViewModel(fetchGroupUseCase: makeFetchGroupUseCase(), actions: actions)
    }
    
    // MARK: GroupFilterView
    func makeGroupFilterViewController(filter: Filter, actions: GroupFilterViewModelActions) -> GroupFilterViewController {
        let groupFilterViewController = GroupFilterViewController(viewModel: makeGroupFilterViewModel(actions: actions))
        groupFilterViewController.initialFilter = filter
        return groupFilterViewController
    }
    
    func makeGroupFilterViewModel(actions: GroupFilterViewModelActions) -> GroupFilterViewModel {
        return DefaultGroupFilterViewModel(fetchCategoryUseCase: makeFetchCategoryUseCase(), actions: actions)
    }
}

extension GroupSceneDIContainer: NotificationSceneDIContainer {}
