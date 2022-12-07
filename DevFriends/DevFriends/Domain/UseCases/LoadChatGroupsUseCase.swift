//
//  LoadChatGroupsUseCase.swift
//  DevFriends
//
//  Created by 유승원 on 2022/11/18.
//

import Foundation
import FirebaseFirestore

protocol LoadChatGroupsUseCase {
    func executeFromLocal() -> [AcceptedGroup]
    func execute(groupListenersProcess: @escaping (_ groupListeners: [ListenerRegistration]) -> Void, groupProcess: @escaping (_ group: AcceptedGroup) -> Void) -> ListenerRegistration
}

final class DefaultLoadChatGroupsUseCase: LoadChatGroupsUseCase {
    private let chatGroupsRepository: ChatGroupsRepository
    
    init(userRepository: UserRepository, chatGroupsRepository: ChatGroupsRepository) {
        self.chatGroupsRepository = chatGroupsRepository
    }
    
    func executeFromLocal() -> [AcceptedGroup] {
        return chatGroupsRepository.fetchFromLocal()
    }
    
    func execute(groupListenersProcess: @escaping (_ groupListeners: [ListenerRegistration]) -> Void, groupProcess: @escaping (_ group: AcceptedGroup) -> Void) -> ListenerRegistration {
        let id = "YkocW98XPzJAsSDVa5qd"
        
        let groupListListener = chatGroupsRepository.fetch(
            userID: id,
            messageListenersProcess: groupListenersProcess,
            groupProcess: groupProcess
        )
        
        return groupListListener
    }
}
