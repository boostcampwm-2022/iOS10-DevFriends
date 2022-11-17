//
//  PostDetailCommentView.swift
//  DevFriends
//
//  Created by 유승원 on 2022/11/15.
//

import UIKit
import SnapKit

struct CommentInfo {
    let writerInfo: PostWriterInfo
    let contents: String
}

final class PostDetailCommentView: UIView {
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.spacing = 20
        return stackView
    }()
    private lazy var commentWriterInfoView: PostWriterInfoView = {
        let commentWriterInfoView = PostWriterInfoView(imageViewRadius: 22.0,
                                                       nameTextSize: 18.0,
                                                       jobTextSize: 14.0)
        return commentWriterInfoView
    }()
    private lazy var commentContentsLabel: UILabel = {
        let commentContentsLabel = UILabel()
        commentContentsLabel.font = .systemFont(ofSize: 18)
        commentContentsLabel.numberOfLines = 0
        return commentContentsLabel
    }()
    
    required init?(coder: NSCoder) {
        fatalError("Init Error")
    }
    
    init() {
        super.init(frame: .zero)
        
        configure()
    }
    
    private func configure() {
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
