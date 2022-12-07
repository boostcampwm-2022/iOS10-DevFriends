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
    var messagesSubject: CurrentValueSubject<[AnyHashable], Never> { get }
    var group: Group { get }
    func getCurrentMessageCount() -> Int
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
    var messagesSubject = CurrentValueSubject<[AnyHashable], Never>([])
    
    // MARK: Private
    private func loadMessages() {
        do {
            try loadChatMessagesUseCase.execute { [weak self] newMessages in
                guard let self = self else {return}
                let nowMessagesWithDate = self.messagesSubject.value
                var totalMessageWithDate: [AnyHashable] = nowMessagesWithDate
                
                for newMessage in newMessages {
                    if let lastMessage = totalMessageWithDate.last as? Message {
                        if !lastMessage.time.isSameDate(as: newMessage.time) {
                            totalMessageWithDate.append(DateMessage(time: newMessage.time))
                        }
                    }else if totalMessageWithDate.isEmpty {
                        totalMessageWithDate.append(DateMessage(time: newMessage.time))
                    }
                    totalMessageWithDate.append(newMessage)
                }
                
                self.messagesSubject.send(totalMessageWithDate)
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
    
    func getCurrentMessageCount() -> Int {
        return messagesSubject.value.count
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
