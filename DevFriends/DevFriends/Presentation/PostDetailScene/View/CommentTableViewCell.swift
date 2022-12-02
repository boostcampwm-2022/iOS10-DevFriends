//
//  CommentTableViewCell.swift
//  DevFriends
//
//  Created by 유승원 on 2022/11/16.
//

import UIKit
import SnapKit

final class CommentTableViewCell: UITableViewCell, ReusableType {
    private let commentView: PostDetailCommentView = {
        let commentView = PostDetailCommentView()
        return commentView
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.layout()
    }
    
    func layout() {
        self.contentView.addSubview(commentView)
        
        self.commentView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.bottom.equalToSuperview().offset(-20)
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
        }
    }
    
    func set(info: CommentInfo) {
        self.commentView.set(commentInfo: info)
    }
}
