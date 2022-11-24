//
//  MogakcoViewModel.swift
//  DevFriends
//
//  Created by 이대현 on 2022/11/15.
//

import Combine

struct MogakcoViewModelActions {
    let showGroupDetail: (Group) -> Void
}

protocol MogakcoViewModelInput {
    func fetchAllMogakco()
    func fetchMogakco(location: Location, distance: Double)
    func nowMogakco(index: Int)
    func nowMogakcoWithAllList(index: Int, distance: Double)
    func didSelectGroup()
}

protocol MogakcoViewModelOutput {
    var allMogakcosSubject: PassthroughSubject<[Group], Never> { get }
    var mogakcosSubject: PassthroughSubject<[Group], Never> { get }
    var nowMogakcoSubject: PassthroughSubject<Group, Never> { get }
}

protocol MogakcoViewModelType: MogakcoViewModelInput, MogakcoViewModelOutput { }

final class MogakcoViewModel: MogakcoViewModelType {
    var allMogakcosSubject = PassthroughSubject<[Group], Never>()
    var mogakcosSubject = PassthroughSubject<[Group], Never>()
    var nowMogakcoSubject = PassthroughSubject<Group, Never>()
    
    private var allMogakcoList: [Group] = []
    private var nowMogakcoList: [Group] = []
    private var nowMogakco: Group?
    
    private let fetchGroupUseCase: FetchGroupUseCase
    private let actions: MogakcoViewModelActions?
    
    init(fetchGroupUseCase: FetchGroupUseCase, actions: MogakcoViewModelActions? = nil) {
        self.fetchGroupUseCase = fetchGroupUseCase
        self.actions = actions
    }
    
    func fetchAllMogakco() {
        Task {
            let groups = try await fetchGroupUseCase
                .execute(groupType: .mogakco, location: nil, distance: nil)
            allMogakcoList = groups
            allMogakcosSubject.send(groups)
        }
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
        if index < nowMogakcoList.count {
            nowMogakco = nowMogakcoList[index]
            nowMogakcoSubject.send(nowMogakcoList[index])
        }
    }
    
    func nowMogakcoWithAllList(index: Int, distance: Double) {
        if index < allMogakcoList.count {
            nowMogakco = allMogakcoList[index]
            nowMogakcoSubject.send(allMogakcoList[index])
            fetchMogakco(location: allMogakcoList[index].location, distance: distance)
        }
    }
    
    func didSelectGroup() {
        guard let nowMogakco = self.nowMogakco else { return }
        actions?.showGroupDetail(nowMogakco)
    }
}
