//
//  ChatViewModel.swift
//  DevFriends
//
//  Created by 유승원 on 2022/11/18.
//

import Combine
import Foundation

struct ChatViewModelActions {
    let showChatContent: (Group) -> Void
}

protocol ChatViewModelInput {
    func didLoadGroups()
    func didSelectGroup(at index: Int)
}

protocol ChatViewModelOutput {
    var groupsSubject: CurrentValueSubject<[Group], Never> { get }
}

protocol ChatViewModel: ChatViewModelInput, ChatViewModelOutput {}

final class DefaultChatViewModel: ChatViewModel {
    private let loadChatGroupsUseCase: LoadChatGroupsUseCase
    private let actions: ChatViewModelActions
    
    // MARK: OUTPUT
    var groupsSubject = CurrentValueSubject<[Group], Never>([])
    
    // MARK: Init
    init(loadChatGroupsUseCase: LoadChatGroupsUseCase, actions: ChatViewModelActions) {
        self.loadChatGroupsUseCase = loadChatGroupsUseCase
        self.actions = actions
    }
    
    // MARK: Private
    private func loadGroups() async {
        let loadTask = Task {
            guard let uid = UserManager.shared.uid else { fatalError("In ChatViewModel, UserManager's uid is nil.") }
            return try await loadChatGroupsUseCase.execute()
        }
        
        let result = await loadTask.result
        
        do {
            groupsSubject.send(try result.get())
        } catch {
            print(error)
        }
    }
}

// MARK: INPUT
extension DefaultChatViewModel {
    func didLoadGroups() {
        Task {
            await loadGroups()
        }
    }
    
    func didSelectGroup(at index: Int) {
        actions.showChatContent(groupsSubject.value[index])
    }
}
