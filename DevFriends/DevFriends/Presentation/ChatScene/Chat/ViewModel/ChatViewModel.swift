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
    var groups: CurrentValueSubject<[Group], Never> { get }
}

protocol ChatViewModel: ChatViewModelInput, ChatViewModelOutput {}

final class DefaultChatViewModel: ChatViewModel {
    private let loadChatGroupsUseCase: LoadChatGroupsUseCase
    private let actions: ChatViewModelActions?
    
    // MARK: OUTPUT
    var groups = CurrentValueSubject<[Group], Never>([])
    
    // MARK: Init
    init(loadChatGroupsUseCase: LoadChatGroupsUseCase, actions: ChatViewModelActions? = nil) {
        self.loadChatGroupsUseCase = loadChatGroupsUseCase
        self.actions = actions
    }
    
    // MARK: Private
    private func loadGroups() async {
        let loadTask = Task {
            return try await loadChatGroupsUseCase.load()
        }
        
        let result = await loadTask.result
        
        do {
            groups.send(try result.get())
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
        actions?.showChatContent(groups.value[index])
    }
}
