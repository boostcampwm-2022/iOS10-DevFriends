//
//  GroupCollectionHeaderView.swift
//  DevFriends
//
//  Created by 상현 on 2022/11/14.
//

import UIKit
import SnapKit

final class GroupCollectionHeaderView: UICollectionReusableView, ReusableType {
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "모임 이름"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    private lazy var filterStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 15
        stackView.isHidden = true
        return stackView
    }()
    
    private lazy var filterLabel: UILabel = {
        let label = UILabel()
        label.text = "최신순"
        label.font = .systemFont(ofSize: 10)
        return label
    }()
    
    private lazy var filterButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "slider.horizontal.3"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(title: String?) {
        titleLabel.text = title
    }
    
    func set(title: String?, _ target: Any?, _ didTapFilterButton: Selector) {
        titleLabel.text = title
        
        filterStackView.isHidden = false
        filterButton.addTarget(target, action: didTapFilterButton, for: .touchUpInside)
    }
    
    // MARK: - Setting
    func layout() {
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.bottom.leading.equalToSuperview()
        }
        
        self.addSubview(filterStackView)
        filterStackView.addArrangedSubview(filterLabel)
        filterStackView.addArrangedSubview(filterButton)
        filterStackView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-10)
            make.centerY.equalTo(titleLabel)
        }
    }
}
