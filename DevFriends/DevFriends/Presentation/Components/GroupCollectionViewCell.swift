//
//  GroupCollectionViewCell.swift
//  DevFriends
//
//  Created by 상현 on 2022/11/14.
//

import SnapKit
import UIKit
import CoreLocation

final class GroupCollectionViewCell: UICollectionViewCell, ReusableType {
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = UIColor(
            red: 242.0 / 255.0,
            green: 242.0 / 255.0,
            blue: 242.0 / 255.0,
            alpha: 1
        )
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "그룹 제목"
        label.font = .systemFont(ofSize: 15, weight: .bold)
        return label
    }()
    
    private let tagStackView: UIStackView = {
        let stackView = UIStackView()
        return stackView
    }()
    
    private let placeLabel: UILabel = {
        let label = UILabel()
        label.text = "📍모임 장소"
        label.font = .systemFont(ofSize: 12, weight: .bold)
        return label
    }()
    
    private let participantLabel: UILabel = {
        let label = UILabel()
        label.text = "👥 0/0"
        label.font = .systemFont(ofSize: 12, weight: .bold)
        label.textAlignment = .right
        return label
    }()
    
    func set(_ group: Group) {
        titleLabel.text = group.title
        participantLabel.text = "👥 \(group.participantIDs.count)/\(group.limitedNumberPeople)"
        let location = CLLocation(latitude: group.location.latitude, longitude: group.location.longitude)
        Task {
            placeLabel.text = "📍\(try await location.placemark() ?? "모임 장소")"
        }
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
        
        self.contentView.addSubview(participantLabel)
        participantLabel.snp.makeConstraints { make in
            make.bottom.equalTo(imageView.snp.bottom).offset(-8)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        self.contentView.addSubview(placeLabel)
        placeLabel.snp.makeConstraints { make in
            make.bottom.equalTo(participantLabel.snp.bottom)
            make.leading.equalTo(titleLabel.snp.leading)
            make.trailing.lessThanOrEqualTo(participantLabel.snp.leading)
        }
    }
    
    private func configureUI() {
        self.contentView.backgroundColor = .white
        self.contentView.layer.cornerRadius = 10
        self.contentView.layer.masksToBounds = true
    }
}
