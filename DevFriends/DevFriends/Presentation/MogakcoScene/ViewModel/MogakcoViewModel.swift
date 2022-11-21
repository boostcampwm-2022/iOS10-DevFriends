//
//  MogakcoViewModel.swift
//  DevFriends
//
//  Created by 이대현 on 2022/11/15.
//

import Combine

class MogakcoViewModel {
    enum Input {
        case fetchAllMogakco
        case fetchMogakco(latitude: Double, longitude: Double)
        case nowMogakcoWithAllList(index: Int)
        case nowMogakco(index: Int)
    }
    
    enum Output {
        case allMogakcos(groups: [Group])
        case mogakcos(groups: [Group])
        case nowMogakco(group: Group)
    }
    
    var allMogakcoList: [Group] = []
    var nowMogakcoList: [Group] = []
    var nowMogakco: Group?
    
    var cancellabels = Set<AnyCancellable>()
    let output = PassthroughSubject<Output, Never>()
    
    let fetchGroupUseCase: FetchGroupUseCase
    
    init(fetchGroupUseCase: FetchGroupUseCase) {
        self.fetchGroupUseCase = fetchGroupUseCase
    }
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            switch event {
            case .fetchAllMogakco:
                self?.fetchAllMogakco()
            case .fetchMogakco(latitude: let latitude, longitude: let longitude):
                self?.fetchMogakco(latitude: latitude, longitude: longitude)
            case .nowMogakco(index: let index):
                self?.nowMogakco(index: index)
            case .nowMogakcoWithAllList(index: let index):
                self?.nowMogakcoWithAllList(index: index)
            }
        }
        .store(in: &cancellabels)
        
        return output.eraseToAnyPublisher()
    }
    
    func fetchAllMogakco() {
        Task {
            let groups = try await fetchGroupUseCase
                .execute(groupType: .mogakco, location: nil)
            allMogakcoList = groups
            output.send(.allMogakcos(groups: groups))
        }
    }
    
    func fetchMogakco(latitude: Double, longitude: Double) {
        Task {
            let groups = try await fetchGroupUseCase
                .execute(groupType: .mogakco, location: (latitude, longitude))
            nowMogakcoList = groups
            output.send(.mogakcos(groups: groups))
        }
    }
    
    func nowMogakco(index: Int) {
        if index < nowMogakcoList.count {
            nowMogakco = nowMogakcoList[index]
            output.send(.nowMogakco(group: nowMogakcoList[index]))
        }
    }
    
    func nowMogakcoWithAllList(index: Int) {
        if index < allMogakcoList.count {
            nowMogakco = allMogakcoList[index]
            output.send(.nowMogakco(group: allMogakcoList[index]))
            fetchMogakco(latitude: allMogakcoList[index].location.latitude, longitude: allMogakcoList[index].location.longitude)
        }
    }
}
