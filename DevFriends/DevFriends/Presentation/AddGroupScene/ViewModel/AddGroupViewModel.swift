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
    func didCategorySelect()
    func didLocationSelect()
    func updateCategory(categories: [Category])
    func updateLocation(location: Location)
}

protocol AddGroupViewModelOutput {
    var didUpdateCategorySubject: PassthroughSubject<[Category], Never> { get }
    var didUpdateLocationSubject: PassthroughSubject<Location, Never> { get }
}

protocol AddGroupViewModel: AddGroupViewModelInput, AddGroupViewModelOutput {
    var categorySelection: [Category]? { get set }
    var locationSelection: Location? { get set }
}

final class DefaultAddGroupViewModel: AddGroupViewModel {
    private let actions: AddGroupViewModelActions?
    var categorySelection: [Category]?
    var locationSelection: Location?
    
    init(actions: AddGroupViewModelActions) {
        self.actions = actions
    }
    
    // MARK: OUTPUT
    var didUpdateCategorySubject = PassthroughSubject<[Category], Never>()
    var didUpdateLocationSubject = PassthroughSubject<Location, Never>()
}

// MARK: INPUT
extension DefaultAddGroupViewModel {
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
}
