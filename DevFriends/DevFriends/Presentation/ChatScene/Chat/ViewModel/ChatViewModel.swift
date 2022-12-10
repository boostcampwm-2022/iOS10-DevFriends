//
//  ChatViewModel.swift
//  DevFriends
//
//  Created by 유승원 on 2022/11/18.
//

import Combine
import Foundation
import FirebaseFirestore

struct ChatViewModelActions {
    let showChatContent: (Group) -> Void
}

protocol ChatViewModelInput {
    func viewWillAppear()
    func didLoadGroups()
    func didSelectGroup(at index: Int)
}

protocol ChatViewModelOutput {
    var groupsSubject: CurrentValueSubject<[AcceptedGroup], Never> { get }
}

protocol ChatViewModel: ChatViewModelInput, ChatViewModelOutput {}

final class DefaultChatViewModel: ChatViewModel {
    private let loadChatGroupsUseCase: LoadChatGroupsUseCase
    private let actions: ChatViewModelActions
    
    private var groupID: String?
    
    // MARK: OUTPUT
    var groupsSubject = CurrentValueSubject<[AcceptedGroup], Never>([])
    
    // MARK: Init
    init(loadChatGroupsUseCase: LoadChatGroupsUseCase, actions: ChatViewModelActions) {
        self.loadChatGroupsUseCase = loadChatGroupsUseCase
        self.actions = actions
    }
    
    // MARK: Private
    private func loadGroupsWithListener() {
        let localAcceptedGroups = loadChatGroupsUseCase.executeFromLocal()
        self.groupsSubject.send(localAcceptedGroups)
        
        loadChatGroupsUseCase.execute { group in
            // SW: 업데이트된 그룹이 중복될 수 있어서 같은 것이 있으면 이전에 있던 걸 지우는 방식으로 진행함
            var groups = self.groupsSubject.value
            if let index = groups.firstIndex(where: { acceptedGroup in
                if acceptedGroup.group.id == group.group.id {
                    return true
                }
                return false
            }) {
                groups.remove(at: index)
                groups.insert(group, at: 0)
            } else {
                groups.insert(group, at: 0)
            }
            
            self.groupsSubject.send(groups)
        }
    }
    
    /// 들어갔던 그룹은 new라는 표시가 뜨지 않게 함
    private func setEnteredGroup() {
        if let groupID = self.groupID {
            var newGroups = groupsSubject.value
            let index = newGroups.firstIndex { group in
                return group.group.id == groupID
            }
            if let index = index {
                newGroups[index].newMessageCount = 0
                groupsSubject.send(newGroups)
            }
        }
    }
}

// MARK: INPUT
extension DefaultChatViewModel {
    func viewWillAppear() {
        setEnteredGroup()
        self.groupID = nil
    }
    
    func didLoadGroups() {
        loadGroupsWithListener()
    }
    
    func didSelectGroup(at index: Int) {
        actions.showChatContent(groupsSubject.value[index].group)
        self.groupID = self.groupsSubject.value[index].group.id
    }
}
