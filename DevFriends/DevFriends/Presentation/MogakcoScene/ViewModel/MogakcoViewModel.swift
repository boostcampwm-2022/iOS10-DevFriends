//
//  MogakcoViewModel.swift
//  DevFriends
//
//  Created by 이대현 on 2022/11/15.
//

import Combine

protocol MogakcoViewModelInput {
    func fetchAllMogakco()
    func fetchMogakco(latitude: Double, longitude: Double)
    func nowMogakco(index: Int)
    func nowMogakcoWithAllList(index: Int)
}

protocol MogakcoViewModelOutput {
    var allMogakcosSubject: PassthroughSubject<[Group], Never> { get set }
    var mogakcosSubject: PassthroughSubject<[Group], Never> { get set }
    var nowMogakcoSubject: PassthroughSubject<Group, Never> { get set }
}

class MogakcoViewModel: MogakcoViewModelInput, MogakcoViewModelOutput {
    var allMogakcosSubject = PassthroughSubject<[Group], Never>()
    var mogakcosSubject = PassthroughSubject<[Group], Never>()
    var nowMogakcoSubject = PassthroughSubject<Group, Never>()
    
    var allMogakcoList: [Group] = []
    var nowMogakcoList: [Group] = []
    var nowMogakco: Group?
    
    var cancellabels = Set<AnyCancellable>()
    
    let fetchGroupUseCase: FetchGroupUseCase
    
    init(fetchGroupUseCase: FetchGroupUseCase) {
        self.fetchGroupUseCase = fetchGroupUseCase
    }
    
    func fetchAllMogakco() {
        Task {
            let groups = try await fetchGroupUseCase
                .execute(groupType: .mogakco, location: nil)
            allMogakcoList = groups
            allMogakcosSubject.send(groups)
        }
    }
    
    func fetchMogakco(latitude: Double, longitude: Double) {
        Task {
            let groups = try await fetchGroupUseCase
                .execute(groupType: .mogakco, location: (latitude, longitude))
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
    
    func nowMogakcoWithAllList(index: Int) {
        if index < allMogakcoList.count {
            nowMogakco = allMogakcoList[index]
            nowMogakcoSubject.send(allMogakcoList[index])
            fetchMogakco(latitude: allMogakcoList[index].location.latitude, longitude: allMogakcoList[index].location.longitude)
        }
    }
}
