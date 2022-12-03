//
//  PostDetailCommentView.swift
//  DevFriends
//
//  Created by 유승원 on 2022/11/15.
//

import UIKit
import SnapKit

struct CommentInfo: Hashable {
    static func == (lhs: CommentInfo, rhs: CommentInfo) -> Bool {
        return lhs.writerInfo == rhs.writerInfo && lhs.contents == rhs.contents
    }
    
    let writerInfo: PostWriterInfo
    let contents: String
}

final class PostDetailCommentView: UIView {
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.spacing = 20
        return stackView
    }()
    private let commentWriterInfoView: PostWriterInfoView = {
        let commentWriterInfoView = PostWriterInfoView(
            imageViewRadius: 22.0,
            nameTextSize: 18.0,
            jobTextSize: 14.0
        )
        return commentWriterInfoView
    }()
    private let commentContentsLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.numberOfLines = 0
        return label
    }()
    
    required init?(coder: NSCoder) {
        fatalError("Init Error")
    }
    
    init() {
        super.init(frame: .zero)
        
        layout()
    }
    
    private func layout() {
        addSubview(stackView)
        stackView.addArrangedSubview(commentWriterInfoView)
        stackView.addArrangedSubview(commentContentsLabel)

        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func set(commentInfo: CommentInfo) {
        commentWriterInfoView.set(info: commentInfo.writerInfo)
        commentContentsLabel.text = commentInfo.contents
    }
}
