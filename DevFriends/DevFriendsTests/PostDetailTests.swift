//
//  PostDetailTests.swift
//  DevFriendsTests
//
//  Created by 상현 on 2022/12/12.
//

import XCTest
@testable import DevFriends

final class PostDetailTests: XCTestCase {
    
    var sut: PostDetailViewModel!

    override func setUpWithError() throws {
        sut = DefaultPostDetailViewModel(
            actions: nil,
            group: DataManager.group[0],
            fetchGroupUseCase: MockLoadGroupUseCase(),
            fetchUserUseCase: MockLoadUserUseCase(),
            fetchCategoryUseCase: MockLoadCategoryUseCase(),
            fetchCommentsUseCase: MockLoadCommentsUseCase(),
            applyGroupUseCase: MockApplyGroupUseCase(),
            sendGroupApplyNotificationUseCase: MockSendGroupApplyNotificationUseCase(),
            updateLikeUseCase: MockUpdateLikeUseCase(),
            postCommentUseCase: MockPostCommentUseCase(),
            sendCommentNotificationUseCase: MockSendCommentNotificationUseCase(),
            loadProfileImageUseCase: MockLoadProfileImageUseCase(),
            updateHitUseCase: MockUpdateHitUseCase()
        )
        
        sut.didLoadGroup()
    }

    override func tearDownWithError() throws {
        sut = nil
    }
    
    func test_didLoadGroup() {
        // given
        let expectedPostWriterInfo = PostWriterInfo(
            name: DataManager.user[0].nickname,
            job: DataManager.user[0].job,
            image: UIImage(data: DataManager.image[DataManager.user[0].id]!)
        )
        
        let expectedPostAttentionInfo = PostAttentionInfo(
            likeOrNot: false,
            commentsCount: DataManager.group[0].commentNumber,
            maxParticipantCount: DataManager.group[0].limitedNumberPeople,
            currentParticipantCount: DataManager.group[0].participantIDs.count
        )
        
        let expectedPostDetailContents = PostDetailContents(
            title: DataManager.group[0].title,
            description: DataManager.group[0].description,
            interests: [DataManager.category[0].name, DataManager.category[1].name],
            time: DataManager.group[0].time.toKoreanString(),
            likeCount: DataManager.group[0].like,
            hitsCount: DataManager.group[0].hit
        )
        
        let expectedComments = Array(DataManager.comment[8...10])

        // when
        
        // then
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            XCTAssertEqual(self.sut.postWriterInfoSubject.value, expectedPostWriterInfo)
            XCTAssertEqual(self.sut.postDetailContentsSubject.value, expectedPostDetailContents)
            XCTAssertEqual(self.sut.postAttentionInfoSubject.value, expectedPostAttentionInfo)
            XCTAssertEqual(self.sut.commentsSubject.value.count, 3)
            XCTAssertEqual(self.sut.commentsSubject.value.map { $0.id }, expectedComments.map { $0.id })
        }
    }
    
    func test_didScrollToBottom() {
        // given
        let expectedComments = Array(DataManager.comment[5...10])
        
        // when
        sut.didScrollToBottom()
        
        // then
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            XCTAssertEqual(self.sut.commentsSubject.value.count, expectedComments.count)
            XCTAssertEqual(self.sut.commentsSubject.value.map { $0.id }, expectedComments.map { $0.id })
        }
    }
    
    func test_didTapCommentPostButton() {
        // given
        let expectedCommentsCount = 4
        let expectedContent = "새로운 댓글입니다."
        
        // when
        sut.didTapCommentPostButton(content: expectedContent)
        
        // then
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            XCTAssertEqual(self.sut.commentsSubject.value.count, expectedCommentsCount)
            XCTAssertEqual(self.sut.commentsSubject.value[0].contents, expectedContent)
        }
    }
}

extension PostDetailTests {
    final class DataManager {
        static var group = [
            Group(
                id: "group01",
                participantIDs: ["user01", "user03"],
                title: "테스트 그룹 1번입니다",
                chatID: "chat01",
                categoryIDs: ["category01", "category02"],
                location: Location(latitude: 0.0, longitude: 0.0),
                description: "user01이 만든 group01",
                time: Date(),
                like: 0,
                hit: 0,
                limitedNumberPeople: 3,
                managerID: "user01",
                type: "스터디",
                commentNumber: 11
            )
        ]
        
        static var user = [
            User(
                id: "user01",
                nickname: "유저 1번",
                job: "유저",
                email: "user01@devfriends.com",
                profileImagePath: "user01_profile",
                categoryIDs: [],
                appliedGroupIDs: [],
                likeGroupIDs: []
            ),
            User(
                id: "user02",
                nickname: "유저 2번",
                job: "유저",
                email: "user02@devfriends.com",
                profileImagePath: "user02_profile",
                categoryIDs: [],
                appliedGroupIDs: [],
                likeGroupIDs: []
            ),
            User(
                id: "user03",
                nickname: "유저 3번",
                job: "유저",
                email: "user03@devfriends.com",
                profileImagePath: "user03_profile",
                categoryIDs: [],
                appliedGroupIDs: [],
                likeGroupIDs: []
            )
        ]
        
        static let category = [
            Category(id: "category01", name: "카테고리01"),
            Category(id: "category02", name: "카테고리02"),
            Category(id: "category03", name: "카테고리03")
        ]
        
        static var comment = [
            Comment(id: "comment01", content: "첫번째 댓글입니다.", time: Date(timeIntervalSince1970: 10000), userID: "user01"),
            Comment(id: "comment02", content: "두번째 댓글입니다.", time: Date(timeIntervalSince1970: 11000), userID: "user02"),
            Comment(id: "comment03", content: "세번째 댓글입니다.", time: Date(timeIntervalSince1970: 12000), userID: "user03"),
            Comment(id: "comment04", content: "네번째 댓글입니다.", time: Date(timeIntervalSince1970: 13000), userID: "user01"),
            Comment(id: "comment05", content: "다섯번째 댓글입니다.", time: Date(timeIntervalSince1970: 14000), userID: "user02"),
            Comment(id: "comment06", content: "여섯번째 댓글입니다.", time: Date(timeIntervalSince1970: 15000), userID: "user03"),
            Comment(id: "comment07", content: "일곱번째 댓글입니다.", time: Date(timeIntervalSince1970: 16000), userID: "user01"),
            Comment(id: "comment08", content: "여덟번째 댓글입니다.", time: Date(timeIntervalSince1970: 17000), userID: "user02"),
            Comment(id: "comment09", content: "아홉번째 댓글입니다.", time: Date(timeIntervalSince1970: 18000), userID: "user03"),
            Comment(id: "comment10", content: "열번째 댓글입니다.", time: Date(timeIntervalSince1970: 19000), userID: "user01"),
            Comment(id: "comment11", content: "열한번째 댓글입니다.", time: Date(timeIntervalSince1970: 20000), userID: "user02")
        ]
        
        static var image: [String: Data] = [
            "user01": UIImage(systemName: "heart")!.jpegData(compressionQuality: 0.8)!,
            "user02": UIImage(systemName: "facemask")!.jpegData(compressionQuality: 0.8)!,
            "user03": UIImage(systemName: "cross.fill")!.jpegData(compressionQuality: 0.8)!
        ]
    }
    
    final class MockLoadGroupUseCase: LoadGroupUseCase {
        func execute(groupType: DevFriends.GroupType?, location: DevFriends.Location?, distance: Double?) async throws -> [DevFriends.Group] {
            return []
        }
        
        func execute(filter: DevFriends.Filter) async throws -> [DevFriends.Group] {
            return []
        }
        
        func execute(ids: [String]) async throws -> [DevFriends.Group] {
            return []
        }
        
        func execute(id: String) async throws -> DevFriends.Group? {
            return DataManager.group.first { $0.id == id }
        }
    }
    
    final class MockLoadUserUseCase: LoadUserUseCase {
        func execute(userId: String) async throws -> DevFriends.User? {
            return DataManager.user.first { $0.id == userId }
        }
    }
    
    final class MockLoadCategoryUseCase: LoadCategoryUseCase {
        func execute() async throws -> [DevFriends.Category] {
            return []
        }
        
        func execute(categoryIds: [String]) async throws -> [DevFriends.Category] {
            return DataManager.category.filter { categoryIds.contains($0.id)}
        }
        
        func execute() async throws -> [String : DevFriends.Category] {
            return [:]
        }
    }
    
    final class MockLoadCommentsUseCase: LoadCommentsUseCase {
        func execute(groupId: String, from: Date?, limit: Int) async throws -> [DevFriends.Comment] {
            var sortedData = DataManager.comment.sorted { (lhs, rhs) -> Bool in
                return lhs.time > rhs.time
            }
            
            if let from = from {
                sortedData = sortedData.filter { $0.time < from }
            }
            
            return Array(sortedData[0..<limit])
        }
    }
    
    final class MockApplyGroupUseCase: ApplyGroupUseCase {
        func execute(groupID: String, user: DevFriends.User) {}
    }
    
    final class MockSendGroupApplyNotificationUseCase: SendGroupApplyNotificationUseCase {
        func execute(from user: DevFriends.User, to group: DevFriends.Group) {}
    }
    
    final class MockUpdateLikeUseCase: UpdateLikeUseCase {
        func execute(like: Bool, user: DevFriends.User, groupID: String) {
            var tempUser = user
            
            if like == true {
                tempUser.likeGroupIDs.append(groupID)
            } else {
                tempUser.likeGroupIDs.removeAll { $0 == groupID }
            }
            
            guard
                let userIndex = DataManager.user.firstIndex(where: { $0.id == user.id }),
                let groupIndex = DataManager.group.firstIndex(where: { $0.id == groupID })
            else { return }
            
            DataManager.user[userIndex] = tempUser
            DataManager.group[groupIndex].like += like ? 1 : -1
        }
    }
    
    final class MockPostCommentUseCase: PostCommentUseCase {
        func execute(comment: DevFriends.Comment, groupId: String) -> String {
            guard let groupIndex = DataManager.group.firstIndex(where: { $0.id == groupId }) else { return "" }
            DataManager.group[groupIndex].commentNumber += 1
            
            let newComment = Comment(id: UUID().uuidString, content: comment.content, time: comment.time, userID: comment.userID)
            DataManager.comment.append(newComment)
                    
            return newComment.id ?? ""
        }
    }
    
    final class MockSendCommentNotificationUseCase: SendCommentNotificationUseCase {
        func execute(sender: DevFriends.User, group: DevFriends.Group, comment: DevFriends.Comment, commentID: String) {}
    }
    
    final class MockLoadProfileImageUseCase: LoadProfileImageUseCase {
        func execute(path: String) async throws -> Data? {
            return DataManager.image[path]
        }
    }
    
    final class MockUpdateHitUseCase: UpdateHitUseCase {
        func execute(groupID: String) {}
    }
}
