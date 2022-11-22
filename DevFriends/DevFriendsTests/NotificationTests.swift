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
    
    func testUpdateNotificationIsOKToTrueUseCase() {
        Task {
            let notification = try await notificationDIContainer.makeLoadNotificationsUseCase().execute()
        }
        let useCase = notificationDIContainer.makeUpdateNotificationIsOKToTrueUseCase()
        let expectation = expectation(description: "loadNotifications")
        Task {
            useCase.execute(notification: <#T##Notification#>)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 30)
    }
}
