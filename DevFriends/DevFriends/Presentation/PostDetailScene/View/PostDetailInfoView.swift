//
//  PostDetailInfoView.swift
//  DevFriends
//
//  Created by 유승원 on 2022/11/14.
//

import UIKit
import SnapKit

final class PostDetailInfoView: UIView {
    private lazy var mainStackView: UIStackView = {
        let mainStackView = UIStackView()
        mainStackView.axis = .vertical
        return mainStackView
    }()
    private lazy var postWriterInfoView: PostWriterInfoView = {
        let postWriterInfoView = PostWriterInfoView()
        return postWriterInfoView
    }()
    private lazy var postDetailContentsView: PostDetailContentsView = {
        let postDetailContentsView = PostDetailContentsView()
        return postDetailContentsView
    }()
    
    required init?(coder: NSCoder) {
        fatalError("Init Error")
    }
    
    init() {
        super.init(frame: .zero)
        
        configure()
    }
    
    private func configure() {
        addSubview(mainStackView)
        mainStackView.addArrangedSubview(postWriterInfoView)
        mainStackView.addArrangedSubview(postDetailContentsView)
        
        mainStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        mainStackView.setCustomSpacing(20, after: postWriterInfoView)
    }
    
    func set(postWriterInfo: PostWriterInfo, postDetailContents: PostDetailContents) {
        postWriterInfoView.set(info: postWriterInfo)
        postDetailContentsView.set(contents: postDetailContents)
    }
}
