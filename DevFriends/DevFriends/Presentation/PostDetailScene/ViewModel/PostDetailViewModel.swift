//
//  PostDetailViewModel.swift
//  DevFriends
//
//  Created by 유승원 on 2022/11/14.
//

import Combine
import UIKit

enum GroupApplyButtonState {
    case manager
    case available
    case applied
    case joined
    case closed
}

struct PostDetailViewModelActions {
    let backToPrevViewController: () -> Void
    let report: () -> Void
}

protocol PostDetailViewModelInput {
    func didLoadGroup()
    func didTapApplyButton()
    func didTapLikeButton()
    func didScrollToBottom()
    func didTapCommentPostButton(content: String)
    func didTouchedBackButton()
    func didTouchedReportButton()
}

protocol PostDetailViewModelOutput {
    var postWriterInfoSubject: CurrentValueSubject<PostWriterInfo, Never> { get }
    var postDetailContentsSubject: CurrentValueSubject<PostDetailContents, Never> { get }
    var postAttentionInfoSubject: CurrentValueSubject<PostAttentionInfo, Never> { get }
    var commentsSubject: CurrentValueSubject<[CommentInfo], Never> { get }
    var scrollToBottomSubject: PassthroughSubject<Void, Never> { get }
    var groupApplyButtonStateSubject: CurrentValueSubject<GroupApplyButtonState, Never> { get }
    var expectedCommentsCount: Int { get }
}

protocol PostDetailViewModel: PostDetailViewModelInput, PostDetailViewModelOutput {}

final class DefaultPostDetailViewModel: PostDetailViewModel {
    private var localUser: User
    private var localJoinedGroupIDs: [String]
    private let actions: PostDetailViewModelActions
    private var group: Group
    private let fetchUserUseCase: LoadUserUseCase
    private let fetchCategoryUseCase: LoadCategoryUseCase
    private let fetchCommentsUseCase: LoadCommentsUseCase
    private let applyGroupUseCase: ApplyGroupUseCase
    private let updateLikeUseCase: UpdateLikeUseCase
    private let postCommentUseCase: PostCommentUseCase
    private let sendCommentNotificationUseCase: SendCommentNotificationUseCase
    private let sendGroupApplyNotificationUseCase: SendGroupApplyNotificationUseCase
    private let loadProfileImageUseCase: LoadProfileImageUseCase
    private let updateHitUseCase: UpdateHitUseCase
    
    private var lastCommentLoadTime: Date?
    var expectedCommentsCount: Int = 0
    
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
        fetchUserUseCase: LoadUserUseCase,
        fetchCategoryUseCase: LoadCategoryUseCase,
        fetchCommentsUseCase: LoadCommentsUseCase,
        applyGroupUseCase: ApplyGroupUseCase,
        sendGroupApplyNotificationUseCase: SendGroupApplyNotificationUseCase,
        updateLikeUseCase: UpdateLikeUseCase,
        postCommentUseCase: PostCommentUseCase,
        sendCommentNotificationUseCase: SendCommentNotificationUseCase,
        loadProfileImageUseCase: LoadProfileImageUseCase,
        updateHitUseCase: UpdateHitUseCase
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
        self.loadProfileImageUseCase = loadProfileImageUseCase
        self.updateHitUseCase = updateHitUseCase
        
        localUser = UserManager.shared.user
        localJoinedGroupIDs = UserManager.shared.joinedGroupIDs ?? []
        
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
            commentsCount: group.commentNumber,
            maxParticipantCount: group.limitedNumberPeople,
            currentParticipantCount: group.participantIDs.count
        )
        
        if group.managerID == UserManager.shared.uid {
            groupApplyButtonStateSubject.value = .manager
        } else if localJoinedGroupIDs.contains(group.id) {
            groupApplyButtonStateSubject.value = .joined
        } else if group.limitedNumberPeople == group.participantIDs.count {
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
    
    private func loadProfile(path: String) async -> UIImage? {
        var image: UIImage?
        if !path.isEmpty {
            do {
                let data = try await loadProfileImageUseCase.execute(path: path + "_th")
                image = UIImage(data: data)
            } catch {
                print(error)
            }
        }
        
        return image
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
    
    private func loadComments(from: Date? = nil, limit: Int = 3) async -> [Comment] {
        var result: [Comment] = []
        do {
            result = try await Task {
                try await fetchCommentsUseCase.execute(groupId: group.id, from: from, limit: limit)
            }.result.get()
            
            expectedCommentsCount += result.count
        } catch {
            print(error)
        }
        return result
    }
}

// MARK: INPUT
extension DefaultPostDetailViewModel {
    func didLoadGroup() {
        updateHitUseCase.execute(groupID: group.id)
        Task {
            guard let user = await loadUser(id: group.managerID) else { return }
            let image = await loadProfile(path: user.id)
            postWriterInfoSubject.value = .init(name: user.nickname, job: user.job, image: image)
            
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
            lastCommentLoadTime = comments.last?.time
            
            for comment in comments {
                guard let user = await loadUser(id: comment.userID) else {
                    commentsSubject.value.append(CommentInfo(
                        writerInfo: .init(name: "userNameError", job: "defaultJob", image: nil),
                        contents: comment.content
                    ))
                    continue
                }
                let profile = await loadProfile(path: user.id)
                commentsSubject.value.append(CommentInfo(
                    writerInfo: .init(name: user.nickname, job: user.job, image: profile),
                    contents: comment.content
                ))
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
        updateLikeUseCase.execute(like: postAttentionInfoSubject.value.likeOrNot, user: localUser, groupID: group.id)
        
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
            guard let loadTime = lastCommentLoadTime else { return }
            let comments = await loadComments(from: loadTime)
            lastCommentLoadTime = comments.last?.time
            
            for comment in comments {
                guard let user = await loadUser(id: comment.userID) else {
                    commentsSubject.value.append(CommentInfo(
                        writerInfo: .init(name: "userNameError", job: "defaultJob", image: nil),
                        contents: comment.content
                    ))
                    continue
                }
                let profile = await loadProfile(path: user.id)
                commentsSubject.value.append(CommentInfo(
                    writerInfo: .init(name: user.nickname, job: user.job, image: profile),
                    contents: comment.content
                ))
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
        
        postAttentionInfoSubject.value.commentsCount += 1
        expectedCommentsCount += 1
        commentsSubject.value.insert(
            CommentInfo(
                writerInfo: .init(
                    name: localUser.nickname,
                    job: localUser.job,
                    image: UserManager.shared.profile
                ),
                contents: comment.content
            )
            ,at: 0
        )
    }
    
    func didTouchedBackButton() {
        actions.backToPrevViewController()
    }
    
    func didTouchedReportButton() {
        actions.report()
    }
}
