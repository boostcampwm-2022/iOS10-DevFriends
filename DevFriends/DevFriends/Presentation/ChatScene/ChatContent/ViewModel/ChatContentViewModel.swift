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
    func back()
    func didTapSettingButton()
}

protocol ChatContentViewModelOutput {
    var messagesSubject: CurrentValueSubject<[Message], Never> { get }
    var group: Group { get }
}

protocol ChatContentViewModel: ChatContentViewModelInput, ChatContentViewModelOutput {}

struct ChatContentViewModelActions {
    let back: () -> Void
    let report: () -> Void
}

final class DefaultChatContentViewModel: ChatContentViewModel {
    let group: Group
    private let loadChatMessagesUseCase: LoadChatMessagesUseCase
    private let sendChatMessagesUseCase: SendChatMessagesUseCase
    private let removeMessageListenerUseCase: RemoveMessageListenerUseCase
    private let actions: ChatContentViewModelActions
    
    init(
        group: Group,
        loadChatMessagesUseCase: LoadChatMessagesUseCase,
        sendChatMessagesUseCase: SendChatMessagesUseCase,
        removeMessageListenerUseCase: RemoveMessageListenerUseCase,
        actions: ChatContentViewModelActions
    ) {
        self.group = group
        self.loadChatMessagesUseCase = loadChatMessagesUseCase
        self.sendChatMessagesUseCase = sendChatMessagesUseCase
        self.removeMessageListenerUseCase = removeMessageListenerUseCase
        self.actions = actions
    }
    
    // MARK: OUTPUT
    var messagesSubject = CurrentValueSubject<[Message], Never>([])
    
    // MARK: Private
    private func loadMessages() {
        do {
            try loadChatMessagesUseCase.execute {
                var tempMessages = self.messagesSubject.value
                tempMessages += $0
                
                self.messagesSubject.send(tempMessages)
            }
        } catch {
            print(error)
        }
    }
    
    private func sendMessage(message: Message) {
        sendChatMessagesUseCase.execute(message: message)
    }
    
    func back() {
        removeMessageListenerUseCase.execute()
        actions.back()
    }
    
    func didTapSettingButton() {
        actions.report()
    }
}

// MARK: INPUT
extension DefaultChatContentViewModel {
    func didLoadMessages() {
        self.loadMessages()
    }
    
    func didSendMessage(text: String) {
        guard let userID = UserManager.shared.uid, let nickname = UserManager.shared.nickname
        else { fatalError("UserDefaults doesn't have values.") }
        let message = Message(content: text, time: Date(), userID: userID, userNickname: nickname)
        sendMessage(message: message)
    }
}
