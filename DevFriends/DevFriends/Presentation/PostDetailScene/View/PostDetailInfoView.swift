//
//  PostDetailInfoView.swift
//  DevFriends
//
//  Created by 유승원 on 2022/11/14.
//

import UIKit
import SnapKit

final class PostDetailInfoView: UIView {
    private let postWriterInfoView = PostWriterInfoView()
    
    private let postDetailContentsView = PostDetailContentsView()
    
    required init?(coder: NSCoder) {
        fatalError("Init Error")
    }
    
    init() {
        super.init(frame: .zero)
        
        self.layout()
        self.style()
    }
    
    private func layout() {
        addSubview(postWriterInfoView)
        postWriterInfoView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(60)
        }
        
        addSubview(postDetailContentsView)
        postDetailContentsView.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview()
            make.top.equalTo(postWriterInfoView.snp.bottom).offset(10)
        }
    }
    
    private func style() {
        self.backgroundColor = .devFriendsReverseBase
    }
    
    func set(postWriterInfo: PostWriterInfo) {
        self.postWriterInfoView.set(info: postWriterInfo)
    }
    
    func set(postDetailContents: PostDetailContents) {
        self.postDetailContentsView.set(contents: postDetailContents)
    }
    
    func set(postWriterInfo: PostWriterInfo, postDetailContents: PostDetailContents) {
        self.postWriterInfoView.set(info: postWriterInfo)
        self.postDetailContentsView.set(contents: postDetailContents)
    }
}
