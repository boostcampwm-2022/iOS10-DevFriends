//
//  MogakcoViewModel.swift
//  DevFriends
//
//  Created by 이대현 on 2022/11/15.
//

import Combine

protocol MogakcoViewModelInput {
    func fetchAllMogakco()
    func fetchMogakco(latitude: Double, longitude: Double, distance: Double)
    func nowMogakco(index: Int)
    func nowMogakcoWithAllList(index: Int, distance: Double)
}

protocol MogakcoViewModelOutput {
    var allMogakcosSubject: PassthroughSubject<[Group], Never> { get }
    var mogakcosSubject: PassthroughSubject<[Group], Never> { get }
    var nowMogakcoSubject: PassthroughSubject<Group, Never> { get }
}

protocol MogakcoViewModelType: MogakcoViewModelInput, MogakcoViewModelOutput { }

class MogakcoViewModel: MogakcoViewModelType {
    var allMogakcosSubject = PassthroughSubject<[Group], Never>()
    var mogakcosSubject = PassthroughSubject<[Group], Never>()
    var nowMogakcoSubject = PassthroughSubject<Group, Never>()
    
    private var allMogakcoList: [Group] = []
    private var nowMogakcoList: [Group] = []
    private var nowMogakco: Group?
    
    private let fetchGroupUseCase: FetchGroupUseCase
    
    init(fetchGroupUseCase: FetchGroupUseCase) {
        self.fetchGroupUseCase = fetchGroupUseCase
    }
    
    func fetchAllMogakco() {
        Task {
            let groups = try await fetchGroupUseCase
                .execute(groupType: .mogakco, location: nil, distance: nil)
            allMogakcoList = groups
            allMogakcosSubject.send(groups)
        }
    }
    
    func fetchMogakco(latitude: Double, longitude: Double, distance: Double) {
        Task {
            let groups = try await fetchGroupUseCase
                .execute(groupType: .mogakco, location: (latitude, longitude), distance: distance)
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
            fetchMogakco(latitude: allMogakcoList[index].location.latitude,
                         longitude: allMogakcoList[index].location.longitude,
                         distance: distance)
        }
    }
}
