//
//  GroupFilterCollectionViewCell.swift
//  DevFriends
//
//  Created by 상현 on 2022/11/15.
//

import SnapKit
import UIKit

final class GroupFilterCollectionViewCell: UICollectionViewCell {
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.text = "태그"
        label.font = .systemFont(ofSize: 15, weight: .bold)
        return label
    }()
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                self.backgroundColor = .systemOrange
                self.layer.borderColor = UIColor.systemOrange.cgColor
            } else {
                self.backgroundColor = .white
                self.layer.borderColor = UIColor.black.cgColor
            }
        }
    }
    
    func configure(_ tag: String) {
        label.text = tag
    }

    // MARK: - Configure UI
    
    override func didMoveToSuperview() {
        buildHierarchy()
        setUpConstraints()
    }
    
    private func buildHierarchy() {
        self.contentView.backgroundColor = .white
        self.contentView.layer.cornerRadius = 10
        self.contentView.layer.masksToBounds = true
        self.layer.borderWidth = 1
        
        self.contentView.addSubview(label)
    }
    
    private func setUpConstraints() {
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
}
