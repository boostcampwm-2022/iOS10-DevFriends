//
//  GroupCollectionViewCell.swift
//  DevFriends
//
//  Created by 상현 on 2022/11/14.
//

import SnapKit
import UIKit

final class GroupCollectionViewCell: UICollectionViewCell, ReusableType {
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
    
    func setGroupInfoUI(_ info: GroupCellInfo) {
        titleLabel.text = info.title
        placeLabel.text = "📍\(info.place)"
        participantLabel.text = "👥\(info.currentPeople)/\(info.peopleLimit)"
    }

    
    // MARK: - Configure UI
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        layout()
        configureUI()
    }
    
    func layout() {
        self.contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.top.bottom.leading.equalToSuperview().inset(20)
            make.width.equalTo(imageView.snp.height)
        }
        
        self.contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.top).offset(8)
            make.leading.equalTo(imageView.snp.trailing).offset(20)
        }
        
        self.contentView.addSubview(tagStackView)
        tagStackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.equalTo(titleLabel.snp.leading)
        }
        
        self.contentView.addSubview(placeLabel)
        placeLabel.snp.makeConstraints { make in
            make.bottom.equalTo(imageView.snp.bottom).offset(-8)
            make.leading.equalTo(titleLabel.snp.leading)
        }
        
        self.contentView.addSubview(participantLabel)
        participantLabel.snp.makeConstraints { make in
            make.bottom.equalTo(placeLabel.snp.bottom)
            make.trailing.equalToSuperview().offset(-60)
        }
    }
    
    private func configureUI() {
        self.contentView.backgroundColor = .white
        self.contentView.layer.cornerRadius = 10
        self.contentView.layer.masksToBounds = true
    }
}
