//
//  GroupCollectionHeaderView.swift
//  DevFriends
//
//  Created by 상현 on 2022/11/14.
//

import UIKit
import SnapKit

final class GroupCollectionHeaderView: UICollectionReusableView {
    
    static let id = "HeaderView"
    
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
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        buildHierarchy()
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
    
    func configure(title: String?) {
        titleLabel.text = title
    }
    
    func configure(title: String?, _ target: Any?, _ didTapFilterButton: Selector) {
        titleLabel.text = title
        
        filterStackView.isHidden = false
        filterButton.addTarget(target, action: didTapFilterButton, for: .touchUpInside)
    }
        
    // MARK: - Configure UI
    
    private func buildHierarchy() {
        self.addSubview(titleLabel)
        self.addSubview(filterStackView)
        
        filterStackView.addArrangedSubview(filterLabel)
        filterStackView.addArrangedSubview(filterButton)
    }
    
    private func setUpConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.bottom.leading.equalToSuperview()
        }
        
        filterStackView.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalTo(titleLabel)
        }
    }
}
