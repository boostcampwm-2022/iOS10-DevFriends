//
//  MogakcoViewModel.swift
//  DevFriends
//
//  Created by 이대현 on 2022/11/15.
//

import Combine

struct MogakcoViewModelActions {
    let showMogakcoModal: ([Group]) -> Void
    let showGroupDetail: (Group) -> Void
    let showNotifications: () -> Void
    let showAddMogakcoScene: () -> Void
}

protocol MogakcoViewModelInput {
    func fetchMogakco(location: Location, distance: Double)
    func nowMogakco(index: Int)
    func nowMogakco(location: Location, distance: Double)
    func didSelectNowMogakco(index: Int)
    func didSelectAddMogakco()
    func didSelectNotifications()
}

protocol MogakcoViewModelOutput {
    var mogakcosSubject: PassthroughSubject<[Group], Never> { get }
    var nowMogakcoSubject: PassthroughSubject<Group, Never> { get }
}

protocol MogakcoViewModelType: MogakcoViewModelInput, MogakcoViewModelOutput { }

final class MogakcoViewModel: MogakcoViewModelType {
    var allMogakcosSubject = PassthroughSubject<[Group], Never>()
    var mogakcosSubject = PassthroughSubject<[Group], Never>()
    var nowMogakcoSubject = PassthroughSubject<Group, Never>()
    
    private var nowMogakcoList: [Group] = []
    private var nowMogakco: Group?
    private var nowMogakcoIndex: Int = -1
    
    private let fetchGroupUseCase: LoadGroupUseCase
    private let actions: MogakcoViewModelActions
    
    init(fetchGroupUseCase: LoadGroupUseCase, actions: MogakcoViewModelActions) {
        self.fetchGroupUseCase = fetchGroupUseCase
        self.actions = actions
    }
    
    func fetchMogakco(location: Location, distance: Double) {
        Task {
            let groups = try await fetchGroupUseCase
                .execute(groupType: .mogakco, location: location, distance: distance)
            nowMogakcoList = groups
            mogakcosSubject.send(groups)
        }
    }
    
    func nowMogakco(index: Int) {
        if index != nowMogakcoIndex && index < nowMogakcoList.count {
            nowMogakcoIndex = index
            nowMogakco = nowMogakcoList[index]
            nowMogakcoSubject.send(nowMogakcoList[index])
        }
    }
    
    func nowMogakco(location: Location, distance: Double) {
        if let index = nowMogakcoList.firstIndex(where: { $0.location == location }) {
            nowMogakcoList.swapAt(index, 0)
            nowMogakcoIndex = 0
            nowMogakco = nowMogakcoList[0]
            nowMogakcoSubject.send(nowMogakcoList[0])
            mogakcosSubject.send(nowMogakcoList)
        } else {
            fetchMogakco(location: location, distance: distance)
        }
    }
    
    func didSelectViewModeButton(location: Location, distance: Double) {
        Task {
            let groups = try await fetchGroupUseCase
                .execute(groupType: .mogakco, location: location, distance: distance)
            nowMogakcoList = groups
            mogakcosSubject.send(groups)
            await MainActor.run {
                actions.showMogakcoModal(nowMogakcoList)
            }
        }
    }
    
    func didSelectNowMogakco(index: Int) {
        if index < nowMogakcoList.count {
            nowMogakco = nowMogakcoList[index]
            nowMogakcoIndex = index
            actions.showGroupDetail(nowMogakcoList[index])
        }
    }
    
    func didSelectAddMogakco() {
        actions.showAddMogakcoScene()
    }
    
    func didSelectNotifications() {
        actions.showNotifications()
    }
}
