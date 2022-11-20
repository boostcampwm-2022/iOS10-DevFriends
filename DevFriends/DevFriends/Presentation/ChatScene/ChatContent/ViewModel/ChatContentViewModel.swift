//
//  ChatContentViewModel.swift
//  DevFriends
//
//  Created by 유승원 on 2022/11/18.
//

import Combine
import Foundation

protocol ChatContentViewModelInput {
    func didLoadMessages()
    func didSendMessage(text: String)
}

protocol ChatContentViewModelOutput {
    var messages: CurrentValueSubject<[Message], Never> { get }
}

protocol ChatContentViewModel: ChatContentViewModelInput, ChatContentViewModelOutput {}

final class DefaultChatContentViewModel: ChatContentViewModel {
    private let group: Group
    private let loadChatMessagesUseCase: LoadChatMessagesUseCase
    private let sendChatMessagesUseCase: SendChatMessagesUseCase
    
    init(group: Group, loadChatMessagesUseCase: LoadChatMessagesUseCase, sendChatMessagesUseCase: SendChatMessagesUseCase) {
        self.group = group
        self.loadChatMessagesUseCase = loadChatMessagesUseCase
        self.sendChatMessagesUseCase = sendChatMessagesUseCase
    }
    
    // MARK: OUTPUT
    var messages = CurrentValueSubject<[Message], Never>([])
    
    // MARK: Private
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
    
    private func sendMessage(message: Message) {
        sendChatMessagesUseCase.send(message: message)
    }
}

// MARK: INPUT
extension DefaultChatContentViewModel {
    func didLoadMessages() {
        Task {
            await loadMessages()
        }
    }
    
    func didSendMessage(text: String) {
        guard let userID = UserDefaults.standard.object(forKey: "uid") as? String
        else { fatalError("사용자의 uid가 로컬에 저장되어 있지 않습니다.") }
        
        let message = Message(content: text, time: Date(), userID: userID)
        sendMessage(message: message)
    }
}
