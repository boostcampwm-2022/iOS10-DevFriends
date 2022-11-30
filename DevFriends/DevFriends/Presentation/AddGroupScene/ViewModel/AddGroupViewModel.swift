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
    var limit: Int? { get set }
    var description: String? { get set }
}

final class DefaultAddGroupViewModel: AddGroupViewModel {
    private let actions: AddGroupViewModelActions?
    var groupType: GroupType
    var categorySelection: [Category]?
    var locationSelection: Location?
    var title: String?
    var limit: Int?
    var description: String?
    
    init(actions: AddGroupViewModelActions, groupType: GroupType) {
        self.actions = actions
        self.groupType = groupType
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
        actions?.showCategoryView()
    }
    
    func didLocationSelect() {
        actions?.showLocationView()
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
        let son = User(id: "nqQW9nOes6UPXRCjBuCy",
                          nickname: "흥민 손",
                          job: "EPL득점왕",
                          profileImagePath: "",
                          categoryIDs: [],
                          appliedGroupIDs: [])

        guard let title = self.title,
              let categories = self.categorySelection,
              let location = self.locationSelection,
              let limit = self.limit,
              let description = self.description else { return }
//        let group = Group(id: son.id,
//                          participantIDs: [son.id],
//                          title: title,
//                          chatID: <#T##String#>,
//                          categoryIDs: categories,
//                          location: location,
//                          description: description,
//                          time: <#T##Date#>,
//                          like: 0,
//                          hit: 0,
//                          limitedNumberPeople: limit,
//                          managerID: son.id,
//                          type: groupType.rawValue)
    }
}
