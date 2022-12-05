//
//  AddGroupViewModel.swift
//  DevFriends
//
//  Created by 이대현 on 2022/11/23.
//

import Combine
import Foundation

struct AddGroupViewModelActions {
    let showCategoryView: () -> Void
    let showLocationView: () -> Void
    let moveBackToParent: () -> Void
}

protocol AddGroupViewModelInput {
    func didConfigureView()
    func didTitleEdited(title: String)
    func didLimitPeopleChanged(limit: Int)
    func didDescriptionChanged(text: String)
    func didCategorySelect()
    func didLocationSelect()
    func updateCategory(categories: [Category])
    func updateLocation(location: Location)
    func didSendGroupInfo()
    func didTouchedBackButton()
}

protocol AddGroupViewModelOutput {
    var didUpdateGroupTypeSubject: PassthroughSubject<GroupType, Never> { get }
    var didUpdateCategorySubject: PassthroughSubject<[Category], Never> { get }
    var didUpdateLocationSubject: PassthroughSubject<Location, Never> { get }
}

protocol AddGroupViewModel: AddGroupViewModelInput, AddGroupViewModelOutput {
    var groupType: GroupType { get set }
    var categorySelection: [Category]? { get set }
    var locationSelection: Location? { get set }
    var title: String? { get set }
    var limit: Int { get set }
    var description: String? { get set }
}

final class DefaultAddGroupViewModel: AddGroupViewModel {
    private let actions: AddGroupViewModelActions
    private let saveChatUseCase: SaveChatUseCase
    private let saveGroupUseCase: SaveGroupUseCase
    var groupType: GroupType
    var categorySelection: [Category]?
    var locationSelection: Location?
    var title: String?
    var limit: Int = 2
    var description: String?
    
    init(
        groupType: GroupType,
        actions: AddGroupViewModelActions,
        saveChatUseCase: SaveChatUseCase,
        saveGroupUseCase: SaveGroupUseCase
    ) {
        self.groupType = groupType
        self.actions = actions
        self.saveChatUseCase = saveChatUseCase
        self.saveGroupUseCase = saveGroupUseCase
    }
    
    // MARK: OUTPUT
    var didUpdateCategorySubject = PassthroughSubject<[Category], Never>()
    var didUpdateLocationSubject = PassthroughSubject<Location, Never>()
    var didUpdateGroupTypeSubject = PassthroughSubject<GroupType, Never>()
}

// MARK: INPUT
extension DefaultAddGroupViewModel {
    func didConfigureView() {
        didUpdateGroupTypeSubject.send(self.groupType)
    }
    
    func didTitleEdited(title: String) {
        self.title = title
    }
    
    func didLimitPeopleChanged(limit: Int) {
        self.limit = limit
    }
    
    func didDescriptionChanged(text: String) {
        self.description = text
    }
    
    func didCategorySelect() {
        actions.showCategoryView()
    }
    
    func didLocationSelect() {
        actions.showLocationView()
    }
    
    func updateCategory(categories: [Category]) {
        self.categorySelection = categories
        didUpdateCategorySubject.send(categories)
    }
    
    func updateLocation(location: Location) {
        self.locationSelection = location
        didUpdateLocationSubject.send(location)
    }
    
    func didSendGroupInfo() {
        let son = User(
            id: "nqQW9nOes6UPXRCjBuCy",
            nickname: "흥민 손",
            job: "EPL득점왕",
            email: "abc@def.com",
            profileImagePath: "",
            categoryIDs: [],
            appliedGroupIDs: [],
            likeGroupIDs: []
        )
        guard let title = self.title,
              let categories = self.categorySelection,
              let location = self.locationSelection,
              let description = self.description else { return } // TODO: alert 띄우기
        // Group을 먼저 만들고, Chat은 groupID를 ID로 이후에 만들기
        let newChat = Chat(id: "", groupID: "")
        let newChatID = saveChatUseCase.execute(chat: newChat)
        let newGroup = Group(
            id: "",
            participantIDs: [son.id],
            title: title,
            chatID: newChatID,
            categoryIDs: categories.map { $0.id },
            location: location,
            description: description,
            time: Date(),
            like: 0,
            hit: 0,
            limitedNumberPeople: limit,
            managerID: son.id,
            type: groupType.rawValue
        )
        saveGroupUseCase.execute(group: newGroup)
        // TODO: User - Group 컬렉션에 해당 그룹 추가해줘야 함
    }
    
    func didTouchedBackButton() {
        actions.moveBackToParent()
    }
}
