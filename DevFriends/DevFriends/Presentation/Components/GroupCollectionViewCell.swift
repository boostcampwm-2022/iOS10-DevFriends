//
//  GroupCollectionViewCell.swift
//  DevFriends
//
//  Created by 상현 on 2022/11/14.
//

import SnapKit
import UIKit

final class GroupCollectionViewCell: UICollectionViewCell {
    
    static let id = "GroupCell"
    
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = UIColor(
            red: 242.0 / 255.0,
            green: 242.0 / 255.0,
            blue: 242.0 / 255.0,
            alpha: 1
        )
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "그룹 제목"
        label.font = .systemFont(ofSize: 15, weight: .bold)
        return label
    }()
    
    private lazy var tagStackView: UIStackView = {
        let stackView = UIStackView()
        return stackView
    }()
    
    private lazy var placeLabel: UILabel = {
        let label = UILabel()
        label.text = "📍모임 장소"
        label.font = .systemFont(ofSize: 12, weight: .bold)
        return label
    }()
    
    private lazy var participantLabel: UILabel = {
        let label = UILabel()
        label.text = "👥 0/0"
        label.font = .systemFont(ofSize: 12, weight: .bold)
        return label
    }()
    
//    func configure(_ group: Group) {
//
//    }
//
    
    // MARK: - Configure UI
    
    override func didMoveToSuperview() {
        buildHierarchy()
        setUpConstraints()
    }
    
    private func buildHierarchy() {
        self.contentView.backgroundColor = .white
        self.contentView.layer.cornerRadius = 10
        self.contentView.layer.masksToBounds = true
        
        self.contentView.addSubview(imageView)
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(tagStackView)
        self.contentView.addSubview(placeLabel)
        self.contentView.addSubview(participantLabel)
    }
    
    private func setUpConstraints() {
        imageView.snp.makeConstraints { make in
            make.top.bottom.leading.equalToSuperview().inset(25)
            make.width.equalTo(imageView.snp.height)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.top).offset(8)
            make.leading.equalTo(imageView.snp.trailing).offset(20)
        }
        
        tagStackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.equalTo(titleLabel.snp.leading)
        }
        
        placeLabel.snp.makeConstraints { make in
            make.bottom.equalTo(imageView.snp.bottom).offset(-8)
            make.leading.equalTo(titleLabel.snp.leading)
        }
        
        participantLabel.snp.makeConstraints { make in
            make.bottom.equalTo(placeLabel.snp.bottom)
            make.trailing.equalToSuperview().offset(-60)
        }
    }
}
