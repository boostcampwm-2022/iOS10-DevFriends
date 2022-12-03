//
//  PostDetailViewModel.swift
//  DevFriends
//
//  Created by 유승원 on 2022/11/14.
//

import Combine
import UIKit

enum GroupApplyButtonState {
    case available
    case applied
    case joined
    case closed
}

struct PostDetailViewModelActions {
    let backToPrevViewController: () -> Void
}

protocol PostDetailViewModelInput {
    func didLoadGroup()
    func didTapApplyButton()
    func didTapLikeButton()
    func didScrollToBottom()
    func didTapCommentPostButton(content: String)
    func didTouchedBackButton()
}

protocol PostDetailViewModelOutput {
    var postWriterInfoSubject: CurrentValueSubject<PostWriterInfo, Never> { get }
    var postDetailContentsSubject: CurrentValueSubject<PostDetailContents, Never> { get }
    var postAttentionInfoSubject: CurrentValueSubject<PostAttentionInfo, Never> { get }
    var commentsSubject: CurrentValueSubject<[CommentInfo], Never> { get }
    var scrollToBottomSubject: PassthroughSubject<Void, Never> { get }
    var groupApplyButtonStateSubject: CurrentValueSubject<GroupApplyButtonState, Never> { get }
}

protocol PostDetailViewModel: PostDetailViewModelInput, PostDetailViewModelOutput {}

final class DefaultPostDetailViewModel: PostDetailViewModel {
    private var localUser: User
    private let actions: PostDetailViewModelActions
    private var group: Group
    private let fetchUserUseCase: FetchUserUseCase
    private let fetchCategoryUseCase: FetchCategoryUseCase
    private let fetchCommentsUseCase: FetchCommentsUseCase
    private let applyGroupUseCase: ApplyGroupUseCase
    private let updateLikeUseCase: UpdateLikeUseCase
    private let postCommentUseCase: PostCommentUseCase
    private let sendCommentNotificationUseCase: SendCommentNotificationUseCase
    private let sendGroupApplyNotificationUseCase: SendGroupApplyNotificationUseCase
    
    // MARK: - OUTPUT
    var postWriterInfoSubject = CurrentValueSubject<PostWriterInfo, Never>(.init(name: "", job: "", image: nil))
    var postDetailContentsSubject = CurrentValueSubject<PostDetailContents, Never>(
        .init(
            title: "",
            description: "",
            interests: [],
            time: "",
            likeCount: 0,
            hitsCount: 0
        )
    )
    var postAttentionInfoSubject = CurrentValueSubject<PostAttentionInfo, Never>(
        .init(
            likeOrNot: false,
            commentsCount: 0,
            maxParticipantCount: 0,
            currentParticipantCount: 0
        )
    )
    var commentsSubject = CurrentValueSubject<[CommentInfo], Never>([])
    var scrollToBottomSubject = PassthroughSubject<Void, Never>()
    var groupApplyButtonStateSubject = CurrentValueSubject<GroupApplyButtonState, Never>(.closed)
    
    init(
        actions: PostDetailViewModelActions,
        group: Group,
        fetchUserUseCase: FetchUserUseCase,
        fetchCategoryUseCase: FetchCategoryUseCase,
        fetchCommentsUseCase: FetchCommentsUseCase,
        applyGroupUseCase: ApplyGroupUseCase,
        sendGroupApplyNotificationUseCase: SendGroupApplyNotificationUseCase,
        updateLikeUseCase: UpdateLikeUseCase,
        postCommentUseCase: PostCommentUseCase,
        sendCommentNotificationUseCase: SendCommentNotificationUseCase
    ) {
        self.actions = actions
        self.group = group
        self.fetchUserUseCase = fetchUserUseCase
        self.fetchCategoryUseCase = fetchCategoryUseCase
        self.fetchCommentsUseCase = fetchCommentsUseCase
        self.applyGroupUseCase = applyGroupUseCase
        self.sendGroupApplyNotificationUseCase = sendGroupApplyNotificationUseCase
        self.updateLikeUseCase = updateLikeUseCase
        self.postCommentUseCase = postCommentUseCase
        self.sendCommentNotificationUseCase = sendCommentNotificationUseCase
        
        // 테스트 유저
        localUser = User(
            id: "nqQW9nOes6UPXRCjBuCy",
            nickname: "흥민 손",
            job: "EPL득점왕",
            profileImagePath: "",
            categoryIDs: [],
            appliedGroupIDs: [],
            likeGroupIDs: []
        )
        
        postDetailContentsSubject.value = .init(
            title: group.title,
            description: group.description,
            interests: [],
            time: group.time.toKoreanString(),
            likeCount: group.like,
            hitsCount: group.hit
        )
        
        postAttentionInfoSubject.value = .init(
            likeOrNot: localUser.likeGroupIDs.contains(group.id),
            commentsCount: 0,
            maxParticipantCount: group.limitedNumberPeople,
            currentParticipantCount: group.participantIDs.count
        )
        
        // 강남구청에서 모각코 id : CMUPNkEns4Pg9ez7fXvg
        
        if group.limitedNumberPeople == group.participantIDs.count {
            groupApplyButtonStateSubject.value = .closed
        } else if localUser.appliedGroupIDs.contains(group.id) {
            groupApplyButtonStateSubject.value = .applied
        } else {
            groupApplyButtonStateSubject.value = .available
        }
    }
    
    private func loadUser(id: String) async -> User? {
        return try? await Task {
            try await fetchUserUseCase.execute(userId: id)
        }.result.get()
    }
    
    private func loadUsers(ids: [String]) async -> [User] {
        var result: [User] = []
        do {
            result = try await Task {
                try await fetchUserUseCase.execute(userIds: ids)
            }.result.get()
        } catch {
            print(error)
        }
        return result
    }
    
    private func loadCategories() async -> [Category] {
        var result: [Category] = []
        do {
            result = try await Task {
                try await fetchCategoryUseCase.execute(categoryIds: group.categoryIDs)
            }.result.get()
        } catch {
            print(error)
        }
        return result
    }
    
    private func loadComments(limit: Int = 5) async -> [Comment] {
        var result: [Comment] = []
        do {
            result = try await Task {
                try await fetchCommentsUseCase.execute(groupId: group.id, limit: commentsSubject.value.count + limit)
            }.result.get()
        } catch {
            print(error)
        }
        return result
    }
}

// MARK: INPUT
extension DefaultPostDetailViewModel {
    func didLoadGroup() {
        Task {
            guard let user = await loadUser(id: group.managerID) else { return }
            postWriterInfoSubject.value = .init(name: user.nickname, job: user.job, image: nil)
            
            let categories = await loadCategories()
            postDetailContentsSubject.value = .init(
                title: group.title,
                description: group.description,
                interests: categories.map { $0.name },
                time: group.time.toKoreanString(),
                likeCount: group.like,
                hitsCount: group.hit
            )
            
            let comments = await loadComments()
            postAttentionInfoSubject.value.commentsCount = comments.count
            
            let commentUsers = await loadUsers(ids: comments.map { $0.userID })
            commentsSubject.value = comments.map { comment in
                guard let user = commentUsers.first(where: { $0.id == comment.userID }) else {
                    return CommentInfo(
                        writerInfo: .init(name: "userNameError", job: "defaultJob", image: nil),
                        contents: comment.content
                    )
                }
                return CommentInfo(
                    writerInfo: .init(name: user.nickname, job: user.job, image: nil),
                    contents: comment.content
                )
            }
        }
    }
    
    func didTapApplyButton() {
        applyGroupUseCase.execute(groupID: group.id, user: localUser)
        sendGroupApplyNotificationUseCase.execute(from: localUser, to: group)
        
        groupApplyButtonStateSubject.value = .applied
    }
    
    func didTapLikeButton() {
        postAttentionInfoSubject.value.likeOrNot.toggle()
        updateLikeUseCase.execute(like: postAttentionInfoSubject.value.likeOrNot, user: localUser, group: group)
        
        if postAttentionInfoSubject.value.likeOrNot == true {
            localUser.likeGroupIDs.append(group.id)
            group.like += 1
        } else {
            localUser.likeGroupIDs.removeAll { $0 == group.id }
            group.like -= 1
        }
    }
    
    func didScrollToBottom() {
        Task {
            let comments = await loadComments()
            postAttentionInfoSubject.value.commentsCount = comments.count
            
            let commentUsers = await loadUsers(ids: comments.map { $0.userID })
            commentsSubject.value = comments.map { comment in
                guard let user = commentUsers.first(where: { $0.id == comment.userID }) else {
                    return CommentInfo(
                        writerInfo: .init(name: "userNameError", job: "defaultJob", image: nil),
                        contents: comment.content
                    )
                }
                return CommentInfo(
                    writerInfo: .init(name: user.nickname, job: user.job, image: nil),
                    contents: comment.content
                )
            }
        }
    }
    
    func didTapCommentPostButton(content: String) {
        let comment = Comment(
            id: "",
            content: content,
            time: Date(),
            userID: localUser.id
        )
        let commentID = postCommentUseCase.execute(comment: comment, groupId: self.group.id)
        
        sendCommentNotificationUseCase.execute(
            sender: self.localUser,
            group: self.group,
            comment: comment,
            commentID: commentID
        )
        
        Task {
            let comments = await loadComments(limit: 1)
            postAttentionInfoSubject.value.commentsCount = comments.count
            
            let commentUsers = await loadUsers(ids: comments.map { $0.userID })
            commentsSubject.value = comments.map { comment in
                guard let user = commentUsers.first(where: { $0.id == comment.userID }) else {
                    return CommentInfo(
                        writerInfo: .init(name: "userNameError", job: "defaultJob", image: nil),
                        contents: comment.content
                    )
                }
                return CommentInfo(
                    writerInfo: .init(name: user.nickname, job: user.job, image: nil),
                    contents: comment.content
                )
            }
//            scrollToBottomSubject.send()
        }
    }
    
    func didTouchedBackButton() {
        actions.backToPrevViewController()
    }
}
