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
}

protocol PostDetailViewModelOutput {
    var postWriterInfoSubject: CurrentValueSubject<PostWriterInfo, Never>{ get }
    var postDetailContentsSubject: CurrentValueSubject<PostDetailContents, Never>{ get }
    var postAttentionInfo: PostAttentionInfo { get }
    var commentsSubject: CurrentValueSubject<[CommentInfo], Never> { get }
}

protocol PostDetailViewModel: PostDetailViewModelInput, PostDetailViewModelOutput {}

final class DefaultPostDetailViewModel: PostDetailViewModel {
    private let group: Group
    private let fetchUserUseCase: FetchUserUseCase
    private let fetchCategoryUseCase: FetchCategoryUseCase
    private let fetchCommentsUseCase: FetchCommentsUseCase
//    private let fetchImageUseCase: FetchImageUseCase
    
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
    
    init(group: Group,
         fetchUserUseCase: FetchUserUseCase,
         fetchCategoryUseCase: FetchCategoryUseCase,
         fetchCommentsUseCase: FetchCommentsUseCase
    ) {
        self.group = group
        self.fetchUserUseCase = fetchUserUseCase
        self.fetchCategoryUseCase = fetchCategoryUseCase
        self.fetchCommentsUseCase = fetchCommentsUseCase
        
        postDetailContentsSubject.value = .init(
            title: group.title,
            description: group.description,
            interests: [],
            time: "0000년 0월 0일 (일) 오전 0:00",
            likeCount: group.like,
            hitsCount: 0
        )
        
        postAttentionInfo = .init(
            likeOrNot: false,
            commentsCount: 0,
            maxParticipantCount: group.limitedNumberPeople,
            currentParticipantCount: group.participantIDs.count
        )
    }
    
    private func loadUser(id: String) async -> User? {
        let loadTask = Task {
            return try await fetchUserUseCase.execute(userId: id)
        }
        let result = await loadTask.result
        
        var resultUser: User?
        do {
            resultUser = try result.get()
        } catch {
            print(error)
        }
        return resultUser
    }
    
    private func loadUsers(ids: [String]) async -> [User] {
        let loadTask = Task {
            return try await fetchUserUseCase.execute(userIds: ids)
        }
        let result = await loadTask.result
        
        var resultUsers = [User]()
        do {
            resultUsers = try result.get()
        } catch {
            print(error)
        }
        return resultUsers
    }
    
    private func loadCategories() async -> [Category] {
        let loadTask = Task {
            return try await fetchCategoryUseCase.execute(categoryIds: group.categories)
        }
        let result = await loadTask.result
        
        var resultCategories = [Category]()
        do {
            resultCategories = try result.get()
        } catch {
            print(error)
        }
        return resultCategories
    }
    
    private func loadComments() async -> [Comment] {
        let loadTask = Task {
            guard let groupId = group.uid else { return [] }
            return try await fetchCommentsUseCase.execute(groupId: groupId)
        }
        let result = await loadTask.result
        
        var resultComments = [Comment]()
        do {
            let items = try result.get()
            items.forEach { item in
                guard let comment = item as? Comment else { return }
                resultComments.append(comment)
            }
        } catch {
            print(error)
        }
        return resultComments
    }
}

extension DefaultPostDetailViewModel {
    func didLoadGroup() {
        Task {
            guard let user = await loadUser(id: group.managerID) else { return }
            postWriterInfoSubject.value = .init(name: user.nickname, job: "defaultJob", image: nil)
            
            let categories = await loadCategories()
            postDetailContentsSubject.value = .init(
                title: group.title,
                description: group.description,
                interests: categories.map{ $0.name },
                time: "0000년 0월 0일 (일) 오전 0:00",
                likeCount: group.like,
                hitsCount: 0
            )
            
            let comments = await loadComments()
            let commentUsers = await loadUsers(ids: comments.map{ $0.userID })
            commentsSubject.value = comments.map { comment in
                guard let user = commentUsers.first(where: { $0.uid == comment.userID }) else {
                    return CommentInfo(writerInfo: .init(name: "userNameError", job: "defaultJob", image: nil), contents: comment.content)
                }
                return CommentInfo(writerInfo: .init(name: user.nickname, job: "defaultJob", image: nil), contents: comment.content)
            }
        }
    }
}
