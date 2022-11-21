//
//  LoadChatGroupsUseCase.swift
//  DevFriends
//
//  Created by 유승원 on 2022/11/18.
//

import Foundation

protocol LoadChatGroupsUseCase {
    func execute() async throws -> [Group]
}

final class DefaultLoadChatGroupsUseCase: LoadChatGroupsUseCase {
    private let userRepository: UserRepository
    private let chatGroupsRepository: ChatGroupsRepository
    
    init(userRepository: UserRepository, chatGroupsRepository: ChatGroupsRepository) {
        self.userRepository = userRepository
        self.chatGroupsRepository = chatGroupsRepository
    }
    
    func execute() async throws -> [Group] {
        let user = try await self.userRepository.fetchUser()
        return try await self.chatGroupsRepository.fetchGroupList(uids: user.groups)
    }
}
