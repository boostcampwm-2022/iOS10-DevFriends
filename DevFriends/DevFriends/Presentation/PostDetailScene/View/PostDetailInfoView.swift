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
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
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
        
        self.layout()
    }
    
    private func layout() {
        self.addSubview(mainStackView)
        self.mainStackView.addArrangedSubview(postWriterInfoView)
        self.mainStackView.addArrangedSubview(postDetailContentsView)
        
        self.mainStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.mainStackView.setCustomSpacing(20, after: postWriterInfoView)
    }
    
    func set(postWriterInfo: PostWriterInfo, postDetailContents: PostDetailContents) {
        self.postWriterInfoView.set(info: postWriterInfo)
        self.postDetailContentsView.set(contents: postDetailContents)
    }
}
