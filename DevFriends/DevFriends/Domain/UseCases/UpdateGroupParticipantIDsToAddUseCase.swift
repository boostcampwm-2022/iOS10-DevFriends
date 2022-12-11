//
//  UpdateGroupParticipantIDsToAddUseCase.swift
//  DevFriends
//
//  Created by 유승원 on 2022/11/22.
//

import Foundation

protocol UpdateGroupParticipantIDsToAddUseCase {
    func execute(groupID: String, senderID: String) async throws
}

final class DefaultUpdateGroupParticipantIDsToAddUseCase: UpdateGroupParticipantIDsToAddUseCase {
    private let groupRepository: GroupRepository
    
    init(groupRepository: GroupRepository) {
        self.groupRepository = groupRepository
    }
    
    func execute(groupID: String, senderID: String) async throws {
        // 1. group 정보를 가져온다.
        guard var group = try await groupRepository.fetch(groupID: groupID) else { return }
        
        // 2. group에 participantIDs에 senderID를 추가하고 업데이트한다.
        var tempParticipantIDs = group.participantIDs
        tempParticipantIDs.append(senderID)
        
        group.participantIDs = tempParticipantIDs
        
        groupRepository.update(groupID: groupID, group: group)
    }
}
