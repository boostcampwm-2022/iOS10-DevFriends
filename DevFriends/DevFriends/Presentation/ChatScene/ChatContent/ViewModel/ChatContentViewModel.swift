//
//  ChatContentViewModel.swift
//  DevFriends
//
//  Created by 유승원 on 2022/11/18.
//

import Combine
import Foundation

struct ChatContentViewModelActions {}

protocol ChatContentViewModelInput {
    func didLoadMessages()
}

protocol ChatContentViewModelOutput {
    var messages: CurrentValueSubject<[Message], Never> { get }
}

protocol ChatContentViewModel: ChatContentViewModelInput, ChatContentViewModelOutput {}

final class DefaultChatContentViewModel: ChatContentViewModel {
    private let group: Group
    private let loadChatMessagesUseCase: LoadChatMessagesUseCase
    
    init(group: Group, loadChatMessagesUseCase: LoadChatMessagesUseCase) {
        self.group = group
        self.loadChatMessagesUseCase = loadChatMessagesUseCase
    }
    
    // MARK: OUTPUT
    var messages = CurrentValueSubject<[Message], Never>([])
    
    private func loadMessages() async {
        let loadTask = Task {
            return try await loadChatMessagesUseCase.load()
        }
        
        let result = await loadTask.result
        
        do {
            messages.send(try result.get())
        } catch {
            print(error)
        }
    }
}

extension DefaultChatContentViewModel {
    func didLoadMessages() {
        Task {
            await loadMessages()
        }
    }
}
