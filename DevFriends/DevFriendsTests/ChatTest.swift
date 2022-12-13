//
//  ChatTest.swift
//  DevFriendsTests
//
//  Created by 유승원 on 2022/12/12.
//

import XCTest
@testable import DevFriends

final class ChatTest: XCTestCase {
    static let messages = [
        Message(id: "abc", content: "안녕하세요", time: Date(timeIntervalSince1970: 0), userID: "mocona@naver.com", userNickname: "mocona"),
        Message(id: "def", content: "오 하이요!", time: Date(timeIntervalSince1970: 5), userID: "yoocona@naver.com", userNickname: "yoocona")
    ]
    
    class MockChatMessagesRepository: ChatMessagesRepository {
        func fetch(chatUID: String, completion: @escaping ([DevFriends.Message]) -> Void) throws {
            let messages = ChatTest.messages
            if chatUID == "abc123" {
                completion(messages)
            }
        }
        
        func send(chatUID: String, message: DevFriends.Message) {}
        
        func removeMessageListener() {}
    }
    func test_LoadChatMessagesUseCase() throws {
        let loadChatMessagesUseCase = DefaultLoadChatMessagesUseCase(
            chatUID: "abc123",
            chatMessagesRepository: MockChatMessagesRepository()
        )
        
        try loadChatMessagesUseCase.execute { messages in
            XCTAssertEqual(ChatTest.messages, messages)
        }
    }
}
