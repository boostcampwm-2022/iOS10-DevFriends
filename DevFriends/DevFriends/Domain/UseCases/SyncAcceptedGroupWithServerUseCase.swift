//
//  SyncAcceptedGroupWithServerUseCase.swift
//  DevFriends
//
//  Created by 유승원 on 2022/12/12.
//

import Foundation

protocol SyncAcceptedGroupWithServerUseCase {
    func execute() async
}

final class DefaultSyncAcceptedGroupWithServerUseCase: SyncAcceptedGroupWithServerUseCase {
    private let chatGroupsRepository: ChatGroupsRepository
    
    init(chatGroupsRepository: ChatGroupsRepository) {
        self.chatGroupsRepository = chatGroupsRepository
    }
    
    func execute() async {
        do {
            try await self.chatGroupsRepository.sync()
        } catch {
            print(error)
        }
    }
}
