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
            } else {
                self.contentView.backgroundColor = .white
                self.contentView.layer.borderColor = UIColor.black.cgColor
            }
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
        self.contentView.backgroundColor = .white
        self.contentView.layer.cornerRadius = 10
        self.contentView.layer.masksToBounds = true
        self.contentView.layer.borderWidth = 1
    }
}
