//
//  PostDetailContentsView.swift
//  DevFriends
//
//  Created by 유승원 on 2022/11/14.
//

import UIKit
import SnapKit

struct PostDetailContents {
    let title: String
    let description: String
    let interests: [String]
    let time: String
    let likeCount: Int
    let hitsCount: Int
}

final class PostDetailContentsView: UIView {
    private lazy var mainStackView: UIStackView = {
        let mainStackView = UIStackView()
        mainStackView.axis = .vertical
        mainStackView.spacing = 0
        return mainStackView
    }()
    private lazy var postTitleLabel: UILabel = {
        let postTitleLabel = UILabel()
        postTitleLabel.textColor = .black
        postTitleLabel.font = .boldSystemFont(ofSize: 25)
        postTitleLabel.sizeToFit()
        return postTitleLabel
    }()
    private lazy var postDescriptionLabel: UILabel = {
        let postDescriptionLabel = UILabel()
        postDescriptionLabel.sizeToFit()
        postDescriptionLabel.font = .systemFont(ofSize: 20)
        postDescriptionLabel.numberOfLines = 0
        return postDescriptionLabel
    }()
    private lazy var postCreationTimeLabel: UILabel = {
        let postCreationTimeLabel = UILabel()
        postCreationTimeLabel.sizeToFit()
        postCreationTimeLabel.font = .systemFont(ofSize: 12)
        postCreationTimeLabel.textColor = UIColor(red: 0.792, green: 0.792, blue: 0.792, alpha: 1)
        return postCreationTimeLabel
    }()
    private lazy var interestsStackView: UIStackView = {
        let interestsStackView = UIStackView()
        interestsStackView.axis = .horizontal
        interestsStackView.spacing = 9
        return interestsStackView
    }()
    private lazy var additionalInfoStackView: UIStackView = {
        let additionalInfoStackView = UIStackView()
        additionalInfoStackView.axis = .horizontal
        return additionalInfoStackView
    }()
    private lazy var likeDisplayView: KeyValueDisplayView = {
        let likeDisplayView = KeyValueDisplayView()
        return likeDisplayView
    }()
    private lazy var hitsDisplayView: KeyValueDisplayView = {
        let hitsDisplayView = KeyValueDisplayView()
        return hitsDisplayView
    }()
    private lazy var emptyView: UIView = {
        let emptyView = UIView()
        return emptyView
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() {
        super.init(frame: .zero)
        
        configure()
    }
    
    private func configure() {
        addSubview(mainStackView)
        mainStackView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
        }
        mainStackView.addArrangedSubview(postTitleLabel)
        mainStackView.addArrangedSubview(postDescriptionLabel)
        mainStackView.addArrangedSubview(interestsStackView)
        mainStackView.addArrangedSubview(postCreationTimeLabel)
        mainStackView.addArrangedSubview(additionalInfoStackView)

        mainStackView.setCustomSpacing(30, after: postTitleLabel)
        mainStackView.setCustomSpacing(25, after: postDescriptionLabel)
        mainStackView.setCustomSpacing(20, after: interestsStackView)
        
        additionalInfoStackView.addArrangedSubview(likeDisplayView)
        additionalInfoStackView.addArrangedSubview(emptyView)
        additionalInfoStackView.addArrangedSubview(hitsDisplayView)
        mainStackView.setCustomSpacing(10, after: postCreationTimeLabel)
        
        additionalInfoStackView.snp.makeConstraints { make in
            make.height.equalTo(12)
        }
        
        snp.makeConstraints { make in
            make.edges.equalTo(mainStackView)
        }
    }
    
    func set(contents: PostDetailContents) {
        self.postTitleLabel.text = contents.title
        self.postDescriptionLabel.text = contents.description
        self.postCreationTimeLabel.text = contents.time
        self.likeDisplayView.set(title: "좋아요", value: String(contents.likeCount))
        self.hitsDisplayView.set(title: "조회수", value: String(contents.hitsCount))
        
        for interest in contents.interests {
            let interestLabel = createInterestLabel(interest)
            self.interestsStackView.addArrangedSubview(interestLabel)
        }
        self.interestsStackView.addArrangedSubview(UIView())
    }
    
    private func createInterestLabel(_ text: String) -> FilledRoundTextLabel {
        let text = "# " + text
        let defaultColor = UIColor(red: 0.907, green: 0.947, blue: 0.876, alpha: 1)
        let interestLabel = FilledRoundTextLabel(text: text, backgroundColor: defaultColor, textColor: .black)
        
        return interestLabel
    }
}
