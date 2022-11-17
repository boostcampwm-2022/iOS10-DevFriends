//
//  PostDetailViewModel.swift
//  DevFriends
//
//  Created by 유승원 on 2022/11/14.
//

import UIKit

protocol PostDetailViewModelInput {}

protocol PostDetailViewModelOutput {
    var postWriterInfo: PostWriterInfo { get }
    var postDetailContents: PostDetailContents { get }
    var postAttentionInfo: PostAttentionInfo { get }
    var comments: [CommentInfo] { get }
}

protocol PostDetailViewModel: PostDetailViewModelInput, PostDetailViewModelOutput {}

final class DefaultPostDetailViewModel: PostDetailViewModel {
    // MARK: OUTPUT
    let postWriterInfo = PostWriterInfo(
        name: "팀 쿡",
        job: "iOS Developer",
        image: nil
    )
    let postDetailContents = PostDetailContents(
        title: "Combine 공부할 사람 내가 가르쳐줌",
        description: "안녕하세요, 3년차 iOS 앱 개발중인 개발자입니다. Combine 같이 공부하고 싶은 분 환영합니다! :)",
        interests: ["Combine", "Swift", "CS 기초"],
        time: "2022년 11월 14일 (월) 오후 3:15",
        likeCount: 30,
        hitsCount: 130
    )
    let postAttentionInfo = PostAttentionInfo(
        likeOrNot: false,
        commentsCount: 3,
        maxParticipantCount: 4,
        currentParticipantCount: 1
    )
    let comments = [
        CommentInfo(
            writerInfo: PostWriterInfo(name: "iOS 뉴비", job: "iOS Developer", image: nil),
            contents: "저의 스승님이 되어주신다면 목숨을 바치겠습니다.."
        ),
        CommentInfo(
            writerInfo: PostWriterInfo(name: "임베디드 올드비", job: "Embeded Developer", image: nil),
            contents: """
                저는 26년차 할아버지 개발자입니다. 앱을 만들어보고 싶은데 컴바인이 뭔가유?
                그거 잘하면 앱 만들 수 있는건가유? 드디어 동적으로 셀 높이를 잡는 것을 성공했는디유..
                테스트 중이여유.. 제발 됐으면 좋겠네유.. 드디어 되는건가유?
                """
        ),
        CommentInfo(
            writerInfo: PostWriterInfo(name: "iOS 개구리", job: "iOS Developer", image: nil),
            contents: "열심히 해볼게요 뽑아만 주세요!"
        )
    ]
}
