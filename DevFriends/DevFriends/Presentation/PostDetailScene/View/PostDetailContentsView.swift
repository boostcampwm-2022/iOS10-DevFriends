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
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 0
        return stackView
    }()
    private lazy var postTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 25)
        label.sizeToFit()
        return label
    }()
    private lazy var postDescriptionLabel: UILabel = {
        let label = UILabel()
        label.sizeToFit()
        label.font = .systemFont(ofSize: 20)
        label.numberOfLines = 0
        return label
    }()
    private lazy var postCreationTimeLabel: UILabel = {
        let label = UILabel()
        label.sizeToFit()
        label.font = .systemFont(ofSize: 12)
        label.textColor = UIColor(red: 0.792, green: 0.792, blue: 0.792, alpha: 1)
        return label
    }()
    private lazy var interestsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 9
        return stackView
    }()
    private lazy var additionalInfoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        return stackView
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
        self.addSubview(mainStackView)
        self.mainStackView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
        }
        self.mainStackView.addArrangedSubview(postTitleLabel)
        self.mainStackView.addArrangedSubview(postDescriptionLabel)
        self.mainStackView.addArrangedSubview(interestsStackView)
        self.mainStackView.addArrangedSubview(postCreationTimeLabel)
        self.mainStackView.addArrangedSubview(additionalInfoStackView)

        self.mainStackView.setCustomSpacing(30, after: postTitleLabel)
        self.mainStackView.setCustomSpacing(25, after: postDescriptionLabel)
        self.mainStackView.setCustomSpacing(20, after: interestsStackView)
        
        self.additionalInfoStackView.addArrangedSubview(likeDisplayView)
        self.additionalInfoStackView.addArrangedSubview(emptyView)
        self.additionalInfoStackView.addArrangedSubview(hitsDisplayView)
        self.mainStackView.setCustomSpacing(10, after: postCreationTimeLabel)
        
        self.additionalInfoStackView.snp.makeConstraints { make in
            make.height.equalTo(12)
        }
        
        self.snp.makeConstraints { make in
            make.edges.equalTo(mainStackView)
        }
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
        let defaultColor = UIColor(red: 0.907, green: 0.947, blue: 0.876, alpha: 1)
        let interestLabel = FilledRoundTextLabel(text: text, backgroundColor: defaultColor, textColor: .black)
        
        return interestLabel
    }
}
