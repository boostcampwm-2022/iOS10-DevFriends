//
//  GroupFilterCollectionViewCell.swift
//  DevFriends
//
//  Created by 상현 on 2022/11/15.
//

import SnapKit
import UIKit

final class GroupFilterCollectionViewCell: UICollectionViewCell, ReusableType {
    private let label: UILabel = {
        let label = UILabel()
        label.text = "태그"
        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    var width: CGFloat {
        return label.frame.width
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                self.contentView.backgroundColor = .systemOrange
                self.contentView.layer.borderColor = UIColor.systemOrange.cgColor
                print("isSelected True: ", label.text)
            } else {
                self.contentView.backgroundColor = .devFriendsCellColor
                self.contentView.layer.borderColor = UIColor.devFriendsBase.cgColor
                print("isSelected False: ", label.text)
            }
        }
    }
    
    func setSelectionUI(_ select: Bool) {
        if select {
            self.contentView.backgroundColor = .systemOrange
            self.contentView.layer.borderColor = UIColor.systemOrange.cgColor
            print("setSelectionUI True: ", label.text)
        } else {
            self.contentView.backgroundColor = .devFriendsCellColor
            self.contentView.layer.borderColor = UIColor.devFriendsBase.cgColor
            print("setSelectionUI False: ", label.text)
        }
    }
    
    func configure(_ tag: String) {
        label.text = tag
        label.sizeToFit()
    }
    
    // MARK: - Configure UI
    
    override func didMoveToSuperview() {
        layout()
        configureUI()
    }
    
    func layout() {
        self.contentView.addSubview(label)
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func configureUI() {
        self.contentView.layer.cornerRadius = 10
        self.contentView.layer.masksToBounds = true
        self.contentView.layer.borderWidth = 1
        self.contentView.backgroundColor = .devFriendsCellColor
        self.contentView.layer.borderColor = UIColor.devFriendsBase.cgColor
    }
}
