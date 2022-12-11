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
    
    func makeChatRepository() -> ChatRepository {
        return DefaultChatRepository()
    }
    
    func makeGroupRepository() -> GroupRepository {
        return DefaultGroupRepository()
    }
    
    func makeUserRepository() -> UserRepository {
        return DefaultUserRepository()
    }
    
    // MARK: UseCases
    func makeLoadCategoryUseCase() -> LoadCategoryUseCase {
        return DefaultLoadCategoryUseCase(categoryRepository: makeCategoryRepository())
    }
    
    func makeSaveChatUseCase() -> SaveChatUseCase {
        return DefaultSaveChatUseCase(chatRepository: makeChatRepository())
    }
    
    func makeSaveGroupUseCase() -> SaveGroupUseCase {
        return DefaultSaveGroupUseCase(groupRepository: makeGroupRepository())
    }
    
    func makeLoadUserUseCase() -> LoadUserUseCase {
        return DefaultLoadUserUseCase(userRepository: makeUserRepository())
    }
    
    func makeSaveUserGroupIDUseCase() -> SaveUserGroupIDUseCase {
        return DefaultSaveUserGroupIDsUseCase(userRepository: makeUserRepository())
    }
    
    // MARK: AddGroupView
    func makeAddGroupViewController(groupType: GroupType, actions: AddGroupViewModelActions) -> AddGroupViewController {
        return AddGroupViewController(viewModel: makeAddGroupViewModel(actions: actions, groupType: groupType))
    }
    
    func makeAddGroupViewModel(actions: AddGroupViewModelActions, groupType: GroupType) -> AddGroupViewModel {
        return DefaultAddGroupViewModel(
            groupType: groupType,
            actions: actions,
            saveChatUseCase: makeSaveChatUseCase(),
            saveGroupUseCase: makeSaveGroupUseCase(),
            loadUserUseCase: makeLoadUserUseCase(),
            saveUserGroupIDUseCase: makeSaveUserGroupIDUseCase()
        )
    }
    
    // MARK: CategoryView
    func makeCategoryViewController(actions: ChooseCategoryViewModelActions, initFilter: [Category]?) -> ChooseCategoryViewController {
        return ChooseCategoryViewController(viewModel: makeCategoryViewModel(actions: actions, initFilter: initFilter))
    }
    
    func makeCategoryViewModel(actions: ChooseCategoryViewModelActions, initFilter: [Category]?) -> ChooseCategoryViewModel {
        return DefaultChooseCategoryViewModel(fetchCategoryUseCase: makeLoadCategoryUseCase(), actions: actions, initFilter: initFilter)
    }
    
    // MARK: LocationView
    func makeLocationViewController(actions: ChooseLocationViewActions) -> ChooseLocationViewController {
        return ChooseLocationViewController(actions: actions)
    }
    
    // MARK: PopupView
    func makePopupViewController(popup: Popup) -> PopupViewController {
        let popupViewController = PopupViewController()
        popupViewController.set(popup: popup)
        return popupViewController
    }
}
