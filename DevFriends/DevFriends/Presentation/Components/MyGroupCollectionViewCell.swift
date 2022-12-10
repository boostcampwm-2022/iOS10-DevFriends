//
//  MyGroupCollectionViewCell.swift
//  DevFriends
//
//  Created by 상현 on 2022/12/07.
//

import SnapKit
import UIKit
import CoreLocation

final class MyGroupCollectionViewCell: UICollectionViewCell, ReusableType {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "그룹 제목"
        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.textColor = .devFriendsBase
        return label
    }()
    
    private let groupTypeLabel: FilledRoundTextLabel = {
        let label = FilledRoundTextLabel(text: "Group", backgroundColor: .devFriendsOrange, textColor: .white)
        return label
    }()
    
    private let placeLabel: UILabel = {
        let label = UILabel()
        label.text = "📍모임 장소"
        label.font = .systemFont(ofSize: 12, weight: .bold)
        label.textColor = .devFriendsBase
        return label
    }()
    
    func set(_ group: Group) {
        titleLabel.text = group.title
        groupTypeLabel.text = group.type
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
        self.contentView.addSubview(groupTypeLabel)
        groupTypeLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.left.equalToSuperview().inset(20)
        }
        
        self.contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(groupTypeLabel.snp.bottom).offset(8)
            make.left.equalTo(groupTypeLabel)
            make.bottom.equalToSuperview().offset(-15)
        }

        self.contentView.addSubview(placeLabel)
        placeLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel)
            make.right.equalToSuperview().offset(-20)
            make.bottom.equalTo(titleLabel)
        }
    }
    
    private func configureUI() {
        self.contentView.backgroundColor = .devFriendsCellColor
        self.contentView.layer.cornerRadius = 10
        self.contentView.layer.masksToBounds = true
    }
}
