//
//  LoadChatGroupsUseCase.swift
//  DevFriends
//
//  Created by 유승원 on 2022/11/18.
//

import Foundation

protocol LoadChatGroupsUseCase {
    func execute() async throws -> [AcceptedGroup]
}

final class DefaultLoadChatGroupsUseCase: LoadChatGroupsUseCase {
    private let chatGroupsRepository: ChatGroupsRepository
    
    init(userRepository: UserRepository, chatGroupsRepository: ChatGroupsRepository) {
        self.chatGroupsRepository = chatGroupsRepository
    }
    
    func execute() async throws -> [AcceptedGroup] {
        // MARK: user를 나중에 어떻게 가져올지 논의해보기
        //guard let uid = UserDefaults.standard.object(forKey: "uid") as? String
        //else { fatalError("UID was not stored!!") }
        let id = "YkocW98XPzJAsSDVa5qd"
        return try await chatGroupsRepository.fetch(userID: id)
    }
}
