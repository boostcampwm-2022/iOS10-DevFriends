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
    lazy var mainStackView: UIStackView = {
        let mainStackView = UIStackView()
        mainStackView.axis = .horizontal
        mainStackView.spacing = 17
        
        return mainStackView
    }()
    lazy var subUIView: UIView = {
        let subUIView = UIView()
        return subUIView
    }()
    lazy var subStackView: UIStackView = {
        let subStackView = UIStackView()
        subStackView.axis = .vertical
        subStackView.spacing = 0
        return subStackView
    }()
    lazy var emptyView: UIView = {
        let emptyView = UIView()
        return emptyView
    }()
    lazy var writerProfileImageView: UIImageView = {
        let writerProfileImageView = UIImageView()
        writerProfileImageView.frame = CGRect(x: 0, y: 0, width: 70, height: 70)
        writerProfileImageView.contentMode = .scaleAspectFit
        writerProfileImageView.layer.cornerRadius = writerProfileImageView.frame.size.width / 2
        writerProfileImageView.clipsToBounds = true
        return writerProfileImageView
    }()
    lazy var writerNameLabel: UILabel = {
        let writerNameLabel = UILabel()
        writerNameLabel.font = .boldSystemFont(ofSize: 25)
        return writerNameLabel
    }()
    lazy var writerJobLabel: UILabel = {
        let writerJobLabel = UILabel()
        writerJobLabel.font = .systemFont(ofSize: 14)
        writerJobLabel.textColor = UIColor(red: 0.792, green: 0.792, blue: 0.792, alpha: 1)
        return writerJobLabel
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        configure()
    }
    
    private func configure() {
        addSubview(mainStackView)
        mainStackView.addArrangedSubview(writerProfileImageView)
        mainStackView.addArrangedSubview(subUIView)
        
        mainStackView.addArrangedSubview(emptyView)
        subUIView.addSubview(subStackView)
        subStackView.addArrangedSubview(writerNameLabel)
        subStackView.addArrangedSubview(writerJobLabel)
        
        mainStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        subStackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
        }
    }
    
    func set(info: PostWriterInfo) {
        writerNameLabel.text = info.name
        writerJobLabel.text = info.job
        
        let image = (info.image ?? UIImage(named: "Image.png"))?.resize(newWidth: writerProfileImageView.frame.width)
        writerProfileImageView.image = image
    }
    
    /// 뷰를 재사용할 때 원하는 사이즈에 맞게 변경할 수 있다.
    func setViewSize(imageViewRadius: Double, nameTextSize: Double, jobTextSize: Double) {
        writerProfileImageView.frame = CGRect(x: 0.0, y: 0.0, width: 2 * imageViewRadius, height: 2 * imageViewRadius)
        writerProfileImageView.layer.cornerRadius = writerProfileImageView.frame.size.width / 2
        writerNameLabel.font = .boldSystemFont(ofSize: nameTextSize)
        writerJobLabel.font = .systemFont(ofSize: jobTextSize)
    }
}
