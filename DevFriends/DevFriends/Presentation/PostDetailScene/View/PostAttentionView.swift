//
//  PostAttentionView.swift
//  DevFriends
//
//  Created by 유승원 on 2022/11/15.
//

import UIKit

struct PostAttentionInfo: Equatable {
    var likeOrNot: Bool
    var commentsCount: Int
    let maxParticipantCount: Int
    let currentParticipantCount: Int
}

final class PostAttentionView: UIView {
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        return stackView
    }()
    let likeButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.plain()
        var titleAttr = AttributedString.init("좋아요")
        titleAttr.font = .systemFont(ofSize: 16)
        titleAttr.foregroundColor = .devFriendsGray
        config.image = .thumbsup
        config.imagePlacement = .leading
        config.baseForegroundColor = .devFriendsGray
        config.imagePadding = 5.0
        config.attributedTitle = titleAttr
        button.configuration = config
        button.semanticContentAttribute = .forceLeftToRight
        return button
    }()
    private let commentsButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.plain()
        config.image = .comment
        config.imagePlacement = .leading
        config.baseForegroundColor = .devFriendsGray
        config.imagePadding = 5.0
        button.configuration = config
        return button
    }()
    private let participantsButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.plain()
        config.image = .twoPerson
        config.imagePlacement = .leading
        config.baseForegroundColor = .devFriendsGray
        config.imagePadding = 5.0
        button.configuration = config
        return button
    }()
    private let emptyView: UIView = {
        let view = UIView()
        return view
    }()
    
    required init?(coder: NSCoder) {
        fatalError("Init Error")
    }
    
    init() {
        super.init(frame: .zero)
        
        layout()
        style()
    }
    
    private func layout() {
        addSubview(mainStackView)
        mainStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        mainStackView.addArrangedSubview(likeButton)
        mainStackView.addArrangedSubview(commentsButton)
        mainStackView.addArrangedSubview(participantsButton)
        mainStackView.addArrangedSubview(emptyView)
    }
    
    private func style() {
        self.backgroundColor = .devFriendsReverseBase
    }
    
    func set(info: PostAttentionInfo) {
        let tintColor: UIColor = info.likeOrNot ? .devFriendsOrange : .devFriendsGray
        
        self.likeButton.configuration?.baseForegroundColor = tintColor
        self.likeButton.configuration?.attributedTitle?.foregroundColor = tintColor
        
        commentsButton.setTitle(String(info.commentsCount), for: .normal)
        participantsButton.setTitle("\(info.currentParticipantCount)/\(info.maxParticipantCount)명", for: .normal)
    }
}
