//
//  PostDetailViewModel.swift
//  DevFriends
//
//  Created by 유승원 on 2022/11/14.
//

import Combine
import UIKit

protocol PostDetailViewModelInput {
    func didLoadGroup()
    func didTapCommentPostButton(content: String)
}

protocol PostDetailViewModelOutput {
    var postWriterInfoSubject: CurrentValueSubject<PostWriterInfo, Never> { get }
    var postDetailContentsSubject: CurrentValueSubject<PostDetailContents, Never> { get }
    var postAttentionInfo: PostAttentionInfo { get }
    var commentsSubject: CurrentValueSubject<[CommentInfo], Never> { get }
    var scrollToBottomSubject: PassthroughSubject<Void, Never> { get }
}

protocol PostDetailViewModel: PostDetailViewModelInput, PostDetailViewModelOutput {}

final class DefaultPostDetailViewModel: PostDetailViewModel {
    private let group: Group
    private let fetchUserUseCase: FetchUserUseCase
    private let fetchCategoryUseCase: FetchCategoryUseCase
    private let fetchCommentsUseCase: FetchCommentsUseCase
    private let postCommentUseCase: PostCommentUseCase
    
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
    var postAttentionInfo: PostAttentionInfo
    var commentsSubject = CurrentValueSubject<[CommentInfo], Never>([])
    var scrollToBottomSubject = PassthroughSubject<Void, Never>()
    
    init(
        group: Group,
        fetchUserUseCase: FetchUserUseCase,
        fetchCategoryUseCase: FetchCategoryUseCase,
        fetchCommentsUseCase: FetchCommentsUseCase,
        postCommentUseCase: PostCommentUseCase
    ) {
        self.group = group
        self.fetchUserUseCase = fetchUserUseCase
        self.fetchCategoryUseCase = fetchCategoryUseCase
        self.fetchCommentsUseCase = fetchCommentsUseCase
        self.postCommentUseCase = postCommentUseCase
        
        postDetailContentsSubject.value = .init(
            title: group.title,
            description: group.description,
            interests: [],
            time: group.time.toKoreanString(),
            likeCount: group.like,
            hitsCount: group.hit
        )
        
        postAttentionInfo = .init(
            likeOrNot: false,
            commentsCount: 0,
            maxParticipantCount: group.limitedNumberPeople,
            currentParticipantCount: group.participantIDs.count
        )
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
                try await fetchCategoryUseCase.execute(categoryIds: group.categories)
            }.result.get()
        } catch {
            print(error)
        }
        return result
    }
    
    private func loadComments() async -> [Comment] {
        var result: [Comment] = []
        do {
            result = try await Task {
                try await fetchCommentsUseCase.execute(groupId: group.id)
            }.result.get()
        } catch {
            print(error)
        }
        return result
    }
}

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
            content: content,
            time: Date(),
            userID: "ac3yRAAR9TKVZKrofpbi"
        )
        postCommentUseCase.execute(comment: comment, groupId: self.group.id)
        
        Task {
            let comments = await loadComments()
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
            scrollToBottomSubject.send()
        }
    }
}
