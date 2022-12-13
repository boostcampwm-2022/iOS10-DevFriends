//
//  PostDetailContentsView.swift
//  DevFriends
//
//  Created by 유승원 on 2022/11/14.
//

import UIKit
import SnapKit

struct PostDetailContents: Equatable {
    let title: String
    let description: String
    let interests: [String]
    let time: String
    let likeCount: Int
    let hitsCount: Int
}

final class PostDetailContentsView: UIView {
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 0
        return stackView
    }()
    private let postTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 25)
        label.numberOfLines = 0
        label.sizeToFit()
        return label
    }()
    private let postDescriptionLabel: UILabel = {
        let label = UILabel()
        label.sizeToFit()
        label.font = .systemFont(ofSize: 20)
        label.numberOfLines = 0
        return label
    }()
    private let postCreationTimeLabel: UILabel = {
        let label = UILabel()
        label.sizeToFit()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .devFriendsGray
        return label
    }()
    private let interestsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 9
        return stackView
    }()
    private let additionalInfoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        return stackView
    }()
    
    private let likeDisplayView = KeyValueDisplayView()
    
    private let hitsDisplayView = KeyValueDisplayView()
    
    private let emptyView: UIView = {
        let view = UIView()
        return view
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() {
        super.init(frame: .zero)
        
        self.layout()
    }
    
    private func layout() {
        self.addSubview(postTitleLabel)
        self.addSubview(postDescriptionLabel)
        self.addSubview(interestsStackView)
        self.addSubview(postCreationTimeLabel)
        self.addSubview(additionalInfoStackView)
        self.postTitleLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.greaterThanOrEqualTo(15)
        }
        self.postDescriptionLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(postTitleLabel.snp.bottom).offset(10)
            make.height.greaterThanOrEqualTo(15)
        }
        self.interestsStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(postDescriptionLabel.snp.bottom).offset(10)
            make.height.equalTo(15)
        }
        
        self.postCreationTimeLabel.snp.makeConstraints { make in
            make.top.equalTo(interestsStackView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
        }
        
        self.additionalInfoStackView.snp.makeConstraints { make in
            make.top.equalTo(postCreationTimeLabel.snp.bottom).offset(10)
            make.bottom.leading.trailing.equalToSuperview()
            make.height.equalTo(12)
        }
        self.additionalInfoStackView.addArrangedSubview(likeDisplayView)
        self.additionalInfoStackView.addArrangedSubview(emptyView)
        self.additionalInfoStackView.addArrangedSubview(hitsDisplayView)
    }
    
    func set(contents: PostDetailContents) {
        self.postTitleLabel.text = contents.title
        self.postDescriptionLabel.text = contents.description
        self.postCreationTimeLabel.text = contents.time
        self.likeDisplayView.set(title: "좋아요", value: String(contents.likeCount))
        self.hitsDisplayView.set(title: "조회수", value: String(contents.hitsCount))
        
        self.interestsStackView.subviews.forEach { $0.removeFromSuperview() }
        for interest in contents.interests {
            let interestLabel = createInterestLabel(interest)
            self.interestsStackView.addArrangedSubview(interestLabel)
        }
        self.interestsStackView.addArrangedSubview(UIView())
    }
    
    private func createInterestLabel(_ text: String) -> FilledRoundTextLabel {
        let text = "# " + text
        let defaultColor: UIColor = .devFriendsLightGray
        let interestLabel = FilledRoundTextLabel(text: text, backgroundColor: defaultColor, textColor: .black)
        
        return interestLabel
    }
}
