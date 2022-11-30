//
//  AddGroupSceneDIContainer.swift
//  DevFriends
//
//  Created by 이대현 on 2022/11/29.
//

import UIKit

struct AddGroupSceneDIContainer {
    // MARK: Flow Coordinators
    func makeAddGroupFlowCoordinator(navigationController: UINavigationController, groupType: GroupType) -> AddGroupCoordinator {
        return AddGroupCoordinator(navigationController: navigationController, dependencies: self, groupType: groupType)
    }
}

extension AddGroupSceneDIContainer: AddGroupFlowCoordinatorDependencies {
    // MARK: Repositories
    func makeCategoryRepository() -> CategoryRepository {
        return DefaultCategoryRepository()
    }
    
    // MARK: UseCases
    func makeFetchCategoryUseCase() -> FetchCategoryUseCase {
        return DefaultFetchCategoryUseCase(categoryRepository: makeCategoryRepository())
    }
    
    // MARK: AddGroupView
    func makeAddGroupViewController(groupType: GroupType, actions: AddGroupViewModelActions) -> AddGroupViewController {
        return AddGroupViewController(viewModel: makeAddGroupViewModel(actions: actions, groupType: groupType))
    }
    
    func makeAddGroupViewModel(actions: AddGroupViewModelActions, groupType: GroupType) -> AddGroupViewModel {
        return DefaultAddGroupViewModel(actions: actions, groupType: groupType)
    }
    
    // MARK: CategoryView
    func makeCategoryViewController(actions: ChooseCategoryViewModelActions) -> ChooseCategoryViewController {
        return ChooseCategoryViewController(viewModel: makeCategoryViewModel(actions: actions))
    }
    
    func makeCategoryViewModel(actions: ChooseCategoryViewModelActions) -> ChooseCategoryViewModel {
        return DefaultChooseCategoryViewModel(fetchCategoryUseCase: makeFetchCategoryUseCase(), actions: actions)
    }
    
    // MARK: LocationView
    func makeLocationViewController(actions: ChooseLocationViewActions) -> ChooseLocationViewController {
        return ChooseLocationViewController(actions: actions)
    }
}
