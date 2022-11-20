//
//  MogakcoViewModel.swift
//  DevFriends
//
//  Created by 이대현 on 2022/11/15.
//

import Combine

class MogakcoViewModel {
    // 핀을 선택하면 나오는 컬렉션 뷰 : mogakcoSubView 변수입니다!
    // 모각코 정보가 담긴 배열을 받아서, CollectionView의 DataSource에 적용해주어야 할 것 같습니다!
    // 마찬가지로 모각코 정보 배열을 목록 보기 버튼을 눌렀을때 올라오는 모달에도 전달해주어야 할 것 같습니다.
    // 올라오는 모달은 showMogakcoModal() 함수에서 생성합니다!
    
    enum Input {
        case fetchAllMogakco
        case fetchMogakco(latitude: Double, longitude: Double)
    }
    
    enum Output {
        case allMogakcos(groups: [Group])
        case mogakcos(groups: [Group])
    }
    
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
            }
        }
        .store(in: &cancellabels)
        
        return output.eraseToAnyPublisher()
    }
    
    func fetchAllMogakco() {
        Task {
            let groups = try await fetchGroupUseCase
                .execute(groupType: .mogakco, location: nil)
            output.send(.allMogakcos(groups: groups))
        }
    }
    
    func fetchMogakco(latitude: Double, longitude: Double) {
        Task {
            let groups = try await fetchGroupUseCase
                .execute(groupType: .mogakco, location: (latitude, longitude))
            output.send(.mogakcos(groups: groups))
        }
    }
}
