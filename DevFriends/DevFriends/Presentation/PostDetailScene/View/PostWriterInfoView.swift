//
//  WriterInfoView.swift
//  DevFriends
//
//  Created by 유승원 on 2022/11/14.
//

import UIKit
import SnapKit

struct PostWriterInfo {
    let name: String
    let job: String
    let image: UIImage?
}

final class PostWriterInfoView: UIView {
    private lazy var mainStackView: UIStackView = {
        let mainStackView = UIStackView()
        mainStackView.axis = .horizontal
        mainStackView.spacing = 17
        mainStackView.distribution = .fill
        return mainStackView
    }()
    private lazy var subStackView: UIStackView = {
        let subStackView = UIStackView()
        subStackView.axis = .vertical
        subStackView.spacing = 0
        subStackView.distribution = .fillEqually
        subStackView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return subStackView
    }()
    private lazy var writerProfileImageView: UIImageView = {
        let writerProfileImageView = UIImageView()
        writerProfileImageView.contentMode = .scaleAspectFit
        writerProfileImageView.clipsToBounds = true
        return writerProfileImageView
    }()
    private lazy var writerNameLabel: UILabel = {
        let writerNameLabel = UILabel()
        writerNameLabel.numberOfLines = 0
        writerNameLabel.sizeToFit()
        return writerNameLabel
    }()
    private lazy var writerJobLabel: UILabel = {
        let writerJobLabel = UILabel()
        writerJobLabel.textColor = UIColor(red: 0.792, green: 0.792, blue: 0.792, alpha: 1)
        writerJobLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        writerJobLabel.numberOfLines = 0
        writerJobLabel.sizeToFit()
        return writerJobLabel
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() {
        super.init(frame: .zero)
        
        style(imageViewRadius: 35, nameTextSize: 25, jobTextSize: 14)
        configure()
    }
    
    init(imageViewRadius: Double, nameTextSize: Double, jobTextSize: Double) {
        super.init(frame: .zero)
        
        style(imageViewRadius: imageViewRadius, nameTextSize: nameTextSize, jobTextSize: jobTextSize)
        configure()
    }
    
    private func configure() {
        addSubview(mainStackView)
        mainStackView.addArrangedSubview(writerProfileImageView)
        
        mainStackView.addArrangedSubview(subStackView)
        subStackView.addArrangedSubview(writerNameLabel)
        subStackView.addArrangedSubview(writerJobLabel)
        
        mainStackView.snp.makeConstraints { make in
            make.top.bottom.left.equalToSuperview()
        }
        
        subStackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
        }
        
        snp.makeConstraints { make in
            make.top.bottom.left.equalTo(mainStackView)
        }
    }
    
    private func style(imageViewRadius: Double, nameTextSize: Double, jobTextSize: Double) {
        writerProfileImageView.frame = CGRect(x: 0.0, y: 0.0, width: 2 * imageViewRadius, height: 2 * imageViewRadius)
        writerProfileImageView.layer.cornerRadius = writerProfileImageView.frame.size.width / 2
        writerNameLabel.font = .boldSystemFont(ofSize: nameTextSize)
        writerJobLabel.font = .systemFont(ofSize: jobTextSize)
    }
    
    func set(info: PostWriterInfo) {
        writerNameLabel.text = info.name
        writerJobLabel.text = info.job
        
        writerNameLabel.sizeToFit()
        writerJobLabel.sizeToFit()
        
        let image = (info.image ?? UIImage(named: "Image.png"))?.resize(newWidth: writerProfileImageView.frame.width)
        writerProfileImageView.image = image
    }
}
