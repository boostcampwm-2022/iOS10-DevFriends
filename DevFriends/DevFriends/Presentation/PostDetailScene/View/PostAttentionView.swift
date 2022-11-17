//
//  PostAttentionView.swift
//  DevFriends
//
//  Created by 유승원 on 2022/11/15.
//

import UIKit

struct PostAttentionInfo {
    let likeOrNot: Bool
    let commentsCount: Int
    let maxParticipantCount: Int
    let currentParticipantCount: Int
}

final class PostAttentionView: UIView {
    lazy var mainStackView: UIStackView = {
        let mainStackView = UIStackView()
        mainStackView.axis = .horizontal
        return mainStackView
    }()
    lazy var likeButton: UIButton = {
        let likeButton = UIButton()
        var config = UIButton.Configuration.plain()
        var titleAttr = AttributedString.init("좋아요")
        titleAttr.font = .systemFont(ofSize: 16)
        titleAttr.foregroundColor = UIColor(red: 0.792, green: 0.792, blue: 0.792, alpha: 1)
        config.image = UIImage(systemName: "hand.thumbsup")
        config.imagePlacement = .leading
        config.baseForegroundColor = UIColor(red: 0.792, green: 0.792, blue: 0.792, alpha: 1)
        config.imagePadding = 5.0
        config.attributedTitle = titleAttr
        likeButton.configuration = config
        likeButton.semanticContentAttribute = .forceLeftToRight
        return likeButton
    }()
    lazy var commentsButton: UIButton = {
        let commentsButton = UIButton()
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "ellipsis.message")
        config.imagePlacement = .leading
        config.baseForegroundColor = UIColor(red: 0.792, green: 0.792, blue: 0.792, alpha: 1)
        config.imagePadding = 5.0
        commentsButton.configuration = config
        return commentsButton
    }()
    lazy var participantsButton: UIButton = {
        let participantsButton = UIButton()
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "person.2")
        config.imagePlacement = .leading
        config.baseForegroundColor = UIColor(red: 0.792, green: 0.792, blue: 0.792, alpha: 1)
        config.imagePadding = 5.0
        participantsButton.configuration = config
        return participantsButton
    }()
    lazy var emptyView: UIView = {
        let emptyView = UIView()
        return emptyView
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
        mainStackView.addArrangedSubview(likeButton)
        mainStackView.addArrangedSubview(commentsButton)
        mainStackView.addArrangedSubview(participantsButton)
        mainStackView.addArrangedSubview(emptyView)
        
        likeButton.snp.makeConstraints { make in
            make.height.equalTo(40)
        }
        commentsButton.snp.makeConstraints { make in
            make.height.equalTo(40)
        }
        participantsButton.snp.makeConstraints { make in
            make.height.equalTo(40)
        }
        
        mainStackView.snp.makeConstraints { make in
            // make.edges.equalToSuperview()
            make.height.equalTo(40)
        }
        
        snp.makeConstraints { make in
            make.edges.equalTo(mainStackView)
            make.size.equalTo(mainStackView)
        }
    }
    
    func set(info: PostAttentionInfo) {
        if info.likeOrNot {
            likeButton.isSelected = true
        }
        
        commentsButton.setTitle(String(info.commentsCount), for: .normal)
        participantsButton.setTitle("\(info.currentParticipantCount)/\(info.maxParticipantCount)명", for: .normal)
    }
}
