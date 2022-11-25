//
//  NotificationTests.swift
//  DevFriendsTests
//
//  Created by 유승원 on 2022/11/22.
//

import XCTest
@testable import DevFriends

class NotificationTests: XCTestCase {
    let notificationDIContainer = NotificationSceneDIContainer()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testLoadNotificationsUseCase() {
        let useCase = notificationDIContainer.makeLoadNotificationsUseCase()
        let expectation = expectation(description: "loadNotifications")
        Task {
            let notifications = try await useCase.execute()
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10)
    }
    
//    func testUpdateNotificationIsAcceptedToTrueUseCase() {
//        Task {
//            let notification = try await notificationDIContainer.makeLoadNotificationsUseCase().execute()
//        }
//        let useCase = notificationDIContainer.makeUpdateNotificationIsAcceptedToTrueUseCase()
//        let expectation = expectation(description: "loadNotifications")
//        Task {
//            useCase.execute(notification: notification)
//            expectation.fulfill()
//        }
//
//        waitForExpectations(timeout: 30)
//    }
    
    func testSendCommentNotificationToHost() {
        let expectation = expectation(description: "test")
        let useCase = DefaultSendCommentNotificationToHostUseCase(notificationRepository: DefaultNotificationRepository())
        
        let group = Group(
            id: "mnYeCkTpbHiATFzHl046",
            participantIDs: ["YkocW98XPzJAsSDVa5qd", "PmxtoQTK2cjArAvUSxAh"],
            title: "Swift를 배워봅시다~",
            chatID: "SHWMLojQYPUZW5U7u24U",
            categories: ["89kKYamuTTGC0rK7VZO8"],
            location: Location(latitude: 37.5029, longitude: 127.0279),
            description: "저랑 같이 공부해요 화이팅!",
            time: Date(),
            like: 1,
            hit: 3,
            limitedNumberPeople: 4,
            managerID: "YkocW98XPzJAsSDVa5qd",
            type: "모각코"
        )
        let sender = User(id: "PmxtoQTK2cjArAvUSxAh", nickname: "빈살만왕세자", job: "사우디 통치자", profileImagePath: "", categories: [""], groups: [])
        let comment = Comment(id: "qRS8XP0uUXjWMLzaP6Xi", content: "저 돈 많아요. 뽑아주세요.", time: Date(), userID: "PmxtoQTK2cjArAvUSxAh")
        
        Task {
            useCase.execute(hostID: "YkocW98XPzJAsSDVa5qd", group: group, sender: sender, comment: comment)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 60)
    }
    
    func testA() {
        let repository = DefaultNotificationRepository()
        let notification = Notification(groupID: "mnYeCkTpbHiATFzHl046", groupTitle: "Swift를 배워봅시다~", type: "모각코")
        repository.send(to: "YkocW98XPzJAsSDVa5qd", notification: notification)
    }
}
