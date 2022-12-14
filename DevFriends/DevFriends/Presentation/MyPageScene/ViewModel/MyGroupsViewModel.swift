//
//  MyGroupsViewModel.swift
//  DevFriends
//
//  Created by 심주미 on 2022/11/23.
//

import Combine
import Foundation

struct MyGroupsViewModelActions {
    let back: () -> Void
    let showPostDetailScene: (Group) -> Void
}

protocol MyGroupsViewModelInput {
    func didLoadGroup()
    func didTapGroup(group: Group)
    func didLeaveGroup(group: Group)
    func didTouchedBackButton()
    func getMyGroupsType() -> MyGroupsType
}

protocol MyGroupsViewModelOutput {
    var groupsSubject: CurrentValueSubject<[Group], Never> { get }
}

protocol MyGroupsViewModel: MyGroupsViewModelInput, MyGroupsViewModelOutput {}

final class DefaultMyGroupsViewModel: MyGroupsViewModel {
    let type: MyGroupsType
    let actions: MyGroupsViewModelActions
    private let loadUserGroupIDsUseCase: LoadUserGroupIDsUseCase
    private let loadGroupUseCase: LoadGroupUseCase
    private let leaveGroupUseCase: LeaveGroupUseCase
    
    private var groupIDs: [String] = []
    var groupsSubject = CurrentValueSubject<[Group], Never>([])
    
    init(
        type: MyGroupsType,
        actions: MyGroupsViewModelActions,
        loadUserGroupIDsUseCase: LoadUserGroupIDsUseCase,
        loadGroupUseCase: LoadGroupUseCase,
        leaveGroupUseCase: LeaveGroupUseCase
    ) {
        self.type = type
        self.actions = actions
        self.loadUserGroupIDsUseCase = loadUserGroupIDsUseCase
        self.loadGroupUseCase = loadGroupUseCase
        self.leaveGroupUseCase = leaveGroupUseCase
    }
    
    private func loadGroupIDs() async -> [String] {
        guard let userID = UserManager.shared.uid else { return [] }
        var result: [String] = []
        do {
            result = try await Task {
                try await loadUserGroupIDsUseCase.execute(userId: userID)
            }.result.get()
        } catch {
            print(error)
        }
        return result
    }
    
    private func loadGroups() async -> [Group] {
        var result: [Group] = []
        if !self.groupIDs.isEmpty {
            do {
                result = try await Task {
                    try await loadGroupUseCase.execute(ids: self.groupIDs)
                }.result.get()
            } catch {
                print(error)
            }
        }
        return result
    }
    
    private func leaveGroup(group: Group) {
        guard let userID = UserManager.shared.uid else { return }
        leaveGroupUseCase.execute(userID: userID, group: group)
        groupsSubject.value.removeAll { $0.id == group.id }
    }
}

extension DefaultMyGroupsViewModel {
    func didLoadGroup() {
        Task {
            switch type {
            case .makedGroup:
                groupIDs = await loadGroupIDs()
                let groups = await loadGroups()
                groupsSubject.value = groups.filter { $0.managerID == UserManager.shared.uid }
            case .participatedGroup:
                groupIDs = await loadGroupIDs()
                let groups = await loadGroups()
                groupsSubject.value = groups.filter { $0.managerID != UserManager.shared.uid }
            case .likedGroup:
                groupIDs = UserManager.shared.likeGroupIDs ?? []
                groupsSubject.value = await loadGroups()
            }
        }
    }
    
    func didTapGroup(group: Group) {
        actions.showPostDetailScene(group)
    }
    
    func didLeaveGroup(group: Group) {
        leaveGroup(group: group)
    }
    
    func didTouchedBackButton() {
        actions.back()
    }
    
    func getMyGroupsType() -> MyGroupsType {
        return type
    }
}
