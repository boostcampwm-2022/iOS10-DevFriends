//
//  LoadChatGroupsUseCase.swift
//  DevFriends
//
//  Created by 유승원 on 2022/11/18.
//

import Foundation

protocol LoadChatGroupsUseCase {
    func execute(uid: String) async throws -> [Group]
}

final class DefaultLoadChatGroupsUseCase: LoadChatGroupsUseCase {
    private let userRepository: UserRepository
    private let chatGroupsRepository: ChatGroupsRepository
    
    init(userRepository: UserRepository, chatGroupsRepository: ChatGroupsRepository) {
        self.userRepository = userRepository
        self.chatGroupsRepository = chatGroupsRepository
    }
    
    func execute(uid: String) async throws -> [Group] {
        let groups = try await self.userRepository.fetchUserGroup(of: uid)
        let groupIDs = groups.map { $0.groupID }
        return try await self.chatGroupsRepository.fetch(uids: groupIDs)
    }
}
