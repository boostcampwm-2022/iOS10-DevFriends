//
//  PostDetailCommentView.swift
//  DevFriends
//
//  Created by 유승원 on 2022/11/15.
//

import UIKit
import SnapKit

final class PostDetailCommentView: UIView {
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        return stackView
    }()
    lazy var commentWriterInfoView: PostWriterInfoView = {
        let commentWriterInfoView = PostWriterInfoView()
        commentWriterInfoView.setViewSize(imageViewRadius: 20.0,
                                          nameTextSize: 18.0,
                                          jobTextSize: 14.0)
        return commentWriterInfoView
    }()
    lazy var commentContentsLabel: UILabel = {
        let commentContentsLabel = UILabel()
        commentContentsLabel.font = .systemFont(ofSize: 18)
        commentContentsLabel.numberOfLines = 0
        return commentContentsLabel
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
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
    
    func set(commentWriterInfo: PostWriterInfo, commentContents: String) {
        commentWriterInfoView.set(info: commentWriterInfo)
        commentContentsLabel.text = commentContents
    }
}
