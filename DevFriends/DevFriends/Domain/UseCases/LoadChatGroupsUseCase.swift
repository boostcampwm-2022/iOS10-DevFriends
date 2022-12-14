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
    func execute(completion: @escaping (_ group: AcceptedGroup) -> Void)
}

final class DefaultLoadChatGroupsUseCase: LoadChatGroupsUseCase {
    private let chatGroupsRepository: ChatGroupsRepository
    
    init(userRepository: UserRepository, chatGroupsRepository: ChatGroupsRepository) {
        self.chatGroupsRepository = chatGroupsRepository
    }
    
    func executeFromLocal() -> [AcceptedGroup] {
        return chatGroupsRepository.fetchFromLocal()
    }
    
    func execute(completion: @escaping (_ group: AcceptedGroup) -> Void) {
        guard let id = UserManager.shared.uid else { fatalError("LoadChatGroupsUseCase에서 UserManager에 uid가 없다고 함") }
        chatGroupsRepository.fetch(userID: id, completion: completion)
    }
}
