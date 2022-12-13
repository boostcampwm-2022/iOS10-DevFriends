//
//  MogakcoTests.swift
//  DevFriendsTests
//
//  Created by 심주미 on 2022/12/12.
//

import Combine
import XCTest
@testable import DevFriends

class TestLoadGroupUseCase: LoadGroupUseCase {
    let groups = [Group(
        id: "1",
        participantIDs: ["1"],
        title: "테스트1",
        chatID: "1",
        categoryIDs: ["1"],
        location: Location(latitude: 0, longitude: 0),
        description: "테스트1",
        time: .now,
        like: 0,
        hit: 0,
        limitedNumberPeople: 4,
        managerID: "user",
        type: "모각코",
        commentNumber: 0
    ), Group(
        id: "2",
        participantIDs: ["1"],
        title: "테스트1",
        chatID: "2",
        categoryIDs: ["1"],
        location: Location(latitude: 0, longitude: 0),
        description: "테스트1",
        time: .now,
        like: 0,
        hit: 0,
        limitedNumberPeople: 4,
        managerID: "user",
        type: "모각코",
        commentNumber: 0
    )]
    
    func execute(groupType: DevFriends.GroupType?, location: DevFriends.Location?, distance: Double?) async throws -> [DevFriends.Group] {
        return groups
    }
    
    func execute(filter: DevFriends.Filter) async throws -> [DevFriends.Group] {
        return groups
    }
    
    func execute(ids: [String]) async throws -> [DevFriends.Group] {
        return groups
    }
    
    func execute(id: String) async throws -> DevFriends.Group? {
        return groups[0]
    }
}


class MogakcoTests: XCTestCase {
    let mogakcoViewModel = MogakcoViewModel(fetchGroupUseCase: TestLoadGroupUseCase(), actions: nil)
    var cancellables = Set<AnyCancellable>()
    func test_fetchMogakco() {
        mogakcoViewModel.fetchMogakco(location: Location(latitude: 0, longitude: 0), distance: 0)
        mogakcoViewModel.mogakcosSubject
            .sink { groups in
                XCTAssertEqual(groups.count, 2)
            }
            .store(in: &cancellables)
    }
    
    func test_nowMogakcoWithIndex() {
        test_fetchMogakco()
        mogakcoViewModel.nowMogakco(index: 1)
        mogakcoViewModel.nowMogakcoSubject
            .sink { group in
                XCTAssertEqual(group.id, "2")
            }
            .store(in: &cancellables)
    }
    
    func test_nowMogakcoWithLocation() {
        test_fetchMogakco()
        mogakcoViewModel.nowMogakco(location: Location(latitude: 0, longitude: 0), distance: 0)
        mogakcoViewModel.nowMogakcoSubject
            .sink { group in
                XCTAssertEqual(group.id, "1")
            }
            .store(in: &cancellables)
    }
    
    func test_didSelectNowMogakco() {
        test_fetchMogakco()
        mogakcoViewModel.didSelectNowMogakco(index: 1)
        mogakcoViewModel.nowMogakcoSubject
            .sink { group in
                XCTAssertEqual(group.id, "2")
            }
            .store(in: &cancellables)
    }
}
