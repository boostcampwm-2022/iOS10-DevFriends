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
}

protocol ChatContentViewModelOutput {
    var messagesSubject: CurrentValueSubject<[Message], Never> { get }
}

protocol ChatContentViewModel: ChatContentViewModelInput, ChatContentViewModelOutput {}

struct ChatContentViewModelActions {
    let back: () -> Void
}

final class DefaultChatContentViewModel: ChatContentViewModel {
    private let group: Group
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
}

// MARK: INPUT
extension DefaultChatContentViewModel {
    func didLoadMessages() {
        self.loadMessages()
    }
    
    func didSendMessage(text: String) {
        // TODO: userID를 여기서 이렇게 접근해도 될까? 의존성을 분리하는 방법도 있을 거 같은데.. 일단 씀
        guard let userID = UserDefaults.standard.object(forKey: "uid") as? String,
            let nickname = UserDefaults.standard.object(forKey: "nickname") as? String
        else { fatalError("사용자의 uid가 로컬에 저장되어 있지 않습니다.") }
        
        let message = Message(content: text, time: Date(), userID: userID, userNickname: nickname)
        sendMessage(message: message)
    }
}
