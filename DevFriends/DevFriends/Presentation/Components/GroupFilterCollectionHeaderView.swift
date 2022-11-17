//
//  GroupFilterCollectionHeaderView.swift
//  DevFriends
//
//  Created by 상현 on 2022/11/15.
//

import UIKit

final class GroupFilterCollectionHeaderView: UICollectionReusableView, ReusableType {
    
    static let id = "FilterHeaderView"
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "헤더 이름"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .left
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        buildHierarchy()
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ title: String?) {
        titleLabel.text = title
    }
    
    // MARK: - Configure UI
    
    private func buildHierarchy() {
        self.addSubview(titleLabel)
    }
    
    private func setUpConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
