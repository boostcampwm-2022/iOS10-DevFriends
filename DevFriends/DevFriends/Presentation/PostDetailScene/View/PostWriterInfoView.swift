//
//  WriterInfoView.swift
//  DevFriends
//
//  Created by 유승원 on 2022/11/14.
//

import UIKit
import SnapKit

struct PostWriterInfo: Hashable {
    let name: String
    let job: String
    let image: UIImage?
}

final class PostWriterInfoView: UIView {
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 17
        stackView.distribution = .fill
        return stackView
    }()
    private let subStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.distribution = .fillEqually
        stackView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return stackView
    }()
    private let writerProfileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    private let writerNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.sizeToFit()
        label.textColor = .devFriendsBase
        return label
    }()
    private let writerJobLabel: UILabel = {
        let label = UILabel()
        label.textColor = .devFriendsGray
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        label.numberOfLines = 0
        label.sizeToFit()
        return label
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() {
        super.init(frame: .zero)
        
        self.style(imageViewRadius: 30, nameTextSize: 25, jobTextSize: 14)
        self.layout(imageViewRadius: 30)
    }
    
    init(imageViewRadius: Double, nameTextSize: Double, jobTextSize: Double) {
        super.init(frame: .zero)
        
        self.style(imageViewRadius: imageViewRadius, nameTextSize: nameTextSize, jobTextSize: jobTextSize)
        self.layout(imageViewRadius: imageViewRadius)
    }
    
    private func layout(imageViewRadius: Double) {
        self.addSubview(mainStackView)
        self.mainStackView.addArrangedSubview(writerProfileImageView)
        writerProfileImageView.snp.makeConstraints { make in
            make.size.equalTo(imageViewRadius * 2)
        }
        
        self.mainStackView.addArrangedSubview(subStackView)
        self.subStackView.addArrangedSubview(writerNameLabel)
        self.subStackView.addArrangedSubview(writerJobLabel)
        
        self.mainStackView.snp.makeConstraints { make in
            make.top.bottom.left.equalToSuperview()
        }
        
        self.subStackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
        }
        
        self.snp.makeConstraints { make in
            make.top.bottom.left.equalTo(mainStackView)
        }
    }
    
    private func style(imageViewRadius: Double, nameTextSize: Double, jobTextSize: Double) {
        self.backgroundColor = .devFriendsReverseBase
        self.writerProfileImageView.layer.cornerRadius = imageViewRadius
        self.writerNameLabel.font = .boldSystemFont(ofSize: nameTextSize)
        self.writerJobLabel.font = .systemFont(ofSize: jobTextSize)
    }
    
    func set(info: PostWriterInfo) {
        self.writerNameLabel.text = info.name
        self.writerJobLabel.text = info.job
        self.writerProfileImageView.image = info.image ?? .defaultProfileImage
    }
}
