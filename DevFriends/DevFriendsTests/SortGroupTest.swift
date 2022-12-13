//
//  SortGroupTest.swift
//  SortGroupTest
//
//  Created by 이대현 on 2022/12/13.
//

import XCTest
@testable import DevFriends

final class SortGroupTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testSortGroupByDistance() throws {
        let sortGroupUseCase = DefaultSortGroupUseCase()
        let groups = [
            Group(id: "", participantIDs: [], title: "GroupA", chatID: "", categoryIDs: [],
                  location: Location(latitude: 50, longitude: 50), description: "", time: Date(), like: 0, hit: 0, limitedNumberPeople: 0, managerID: "", type: "", commentNumber: 0),
            Group(id: "", participantIDs: [], title: "GroupB", chatID: "", categoryIDs: [],
                  location: Location(latitude: 40, longitude: 40), description: "", time: Date(), like: 0, hit: 0, limitedNumberPeople: 0, managerID: "", type: "", commentNumber: 0),
            Group(id: "", participantIDs: [], title: "GroupC", chatID: "", categoryIDs: [],
                  location: Location(latitude: 30, longitude: 30), description: "", time: Date(), like: 0, hit: 0, limitedNumberPeople: 0, managerID: "", type: "", commentNumber: 0)
        ]
        let result = sortGroupUseCase.execute(groups: groups, by: .closest, userLocation: Location(latitude: 10, longitude: 10))
            .map { $0.title }
        let expectation = ["GroupC", "GroupB", "GroupA"]
        XCTAssertEqual(result, expectation)
    }
    
    func testSortGroupByDate() throws {
        let sortGroupUseCase = DefaultSortGroupUseCase()
        let unixTime = Date().timeIntervalSince1970
        let groups = [
            Group(id: "", participantIDs: [], title: "GroupA", chatID: "", categoryIDs: [],
                  location: Location(latitude: 50, longitude: 50), description: "",
                  time: Date(timeIntervalSince1970: unixTime + 100), like: 0, hit: 0, limitedNumberPeople: 0, managerID: "", type: "", commentNumber: 0),
            Group(id: "", participantIDs: [], title: "GroupB", chatID: "", categoryIDs: [],
                  location: Location(latitude: 40, longitude: 40), description: "",
                  time: Date(timeIntervalSince1970: unixTime + 200), like: 0, hit: 0, limitedNumberPeople: 0, managerID: "", type: "", commentNumber: 0),
            Group(id: "", participantIDs: [], title: "GroupC", chatID: "", categoryIDs: [],
                  location: Location(latitude: 30, longitude: 30), description: "",
                  time: Date(timeIntervalSince1970: unixTime + 300), like: 0, hit: 0, limitedNumberPeople: 0, managerID: "", type: "", commentNumber: 0)
        ]
        let result = sortGroupUseCase.execute(groups: groups, by: .newest, userLocation: nil)
            .map { $0.title }
        let expectation = ["GroupC", "GroupB", "GroupA"]
        XCTAssertEqual(result, expectation)
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
