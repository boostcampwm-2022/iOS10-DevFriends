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
    var postDetailContents: PostDetailContents { get }
    var postAttentionInfo: PostAttentionInfo { get }
    var comments: [CommentInfo] { get }
}

protocol PostDetailViewModel: PostDetailViewModelInput, PostDetailViewModelOutput {}

final class DefaultPostDetailViewModel: PostDetailViewModel {
    private let group: Group
    private let fetchUserUseCase: FetchUserUseCase
//    private let fetchImageUseCase: FetchImageUseCase
    
    // MARK: - OUTPUT
    var postWriterInfoSubject = CurrentValueSubject<PostWriterInfo, Never>(.init(name: "", job: "", image: nil))
    var postDetailContents: PostDetailContents
    var postAttentionInfo: PostAttentionInfo
    var comments: [CommentInfo]
    
    init(group: Group, fetchUserUseCase: FetchUserUseCase) {
        self.group = group
        self.fetchUserUseCase = fetchUserUseCase
        
        postDetailContents = .init(
            title: group.title,
            description: group.description,
            interests: group.categories,
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
        comments = []
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
}

extension DefaultPostDetailViewModel {
    func didLoadGroup() {
        Task {
            guard let user = await loadUser(id: group.managerID) else { return }
            postWriterInfoSubject.value = .init(name: user.nickname, job: "defaultJob", image: nil)
        }
    }
}
