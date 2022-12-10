//
//  AddGroupViewModel.swift
//  DevFriends
//
//  Created by 이대현 on 2022/11/23.
//

import Combine
import Foundation

struct AddGroupViewModelActions {
    let showCategoryView: ([Category]?) -> Void
    let showLocationView: () -> Void
    let moveBackToParent: () -> Void
    let showPopup: (Popup) -> Void
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
    var didSendGroupSubject: PassthroughSubject<Void, Never> { get }
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
    private let loadUserUseCase: LoadUserUseCase
    private let saveUserGroupIDUseCase: SaveUserGroupIDUseCase
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
        saveGroupUseCase: SaveGroupUseCase,
        loadUserUseCase: LoadUserUseCase,
        saveUserGroupIDUseCase: SaveUserGroupIDUseCase
    ) {
        self.groupType = groupType
        self.actions = actions
        self.saveChatUseCase = saveChatUseCase
        self.saveGroupUseCase = saveGroupUseCase
        self.loadUserUseCase = loadUserUseCase
        self.saveUserGroupIDUseCase = saveUserGroupIDUseCase
    }
    
    // MARK: OUTPUT
    var didUpdateCategorySubject = PassthroughSubject<[Category], Never>()
    var didUpdateLocationSubject = PassthroughSubject<Location, Never>()
    var didUpdateGroupTypeSubject = PassthroughSubject<GroupType, Never>()
    var didSendGroupSubject = PassthroughSubject<Void, Never>()
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
        actions.showCategoryView(self.categorySelection)
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
        let user = UserManager.shared.user
        guard let title = self.title,
              let categories = self.categorySelection,
              let location = self.locationSelection,
              let description = self.description else {
            let popup = Popup(title: "", message: popupMessage(), close: "", doneAction: {})
            actions.showPopup(popup)
            return
        }
        let newChat = Chat(id: "", groupID: "")
        let newChatID = saveChatUseCase.execute(chat: newChat)
        let newGroup = Group(
            id: "",
            participantIDs: [user.id],
            title: title,
            chatID: newChatID,
            categoryIDs: categories.map { $0.id },
            location: location,
            description: description,
            time: Date(),
            like: 0,
            hit: 0,
            limitedNumberPeople: limit,
            managerID: user.id,
            type: groupType.rawValue,
            commentNumber: 0
        )
        let newGroupID = saveGroupUseCase.execute(group: newGroup)
        saveUserGroupIDUseCase.execute(userId: user.id, groupID: newGroupID)
        let popup = Popup(title: "", message: "\(self.groupType.rawValue) 모집 글을 올렸어요.", close: "", doneAction: {})
        actions.showPopup(popup)
        didSendGroupSubject.send()
        actions.moveBackToParent()
    }
    
    func didTouchedBackButton() {
        actions.moveBackToParent()
    }
    
    private func popupMessage() -> String {
        var errors: [String] = []
        if self.title == nil || (self.title != nil && self.title!.isEmpty) {
            errors.append("제목")
        }
        if self.categorySelection == nil {
            errors.append("카테고리")
        }
        if self.locationSelection == nil {
            errors.append("위치")
        }
        if self.description == nil {
            errors.append("내용")
        }
        let errorString = errors.joined(separator: ", ")
        return errorString + "은 필수 입력 항목이에요."
    }
}
