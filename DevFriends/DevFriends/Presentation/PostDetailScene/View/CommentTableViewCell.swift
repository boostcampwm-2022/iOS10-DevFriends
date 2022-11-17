//
//  CommentTableViewCell.swift
//  DevFriends
//
//  Created by 유승원 on 2022/11/16.
//

import UIKit
import SnapKit

final class CommentTableViewCell: UITableViewCell {
    private lazy var commentView: PostDetailCommentView = {
        let commentView = PostDetailCommentView()
        return commentView
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configure()
    }
    
    private func configure() {
        contentView.addSubview(commentView)
        
        commentView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.bottom.equalToSuperview().offset(-20)
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
        }
    }
    
    func set(info: CommentInfo) {
        commentView.set(commentInfo: info)
    }
}
