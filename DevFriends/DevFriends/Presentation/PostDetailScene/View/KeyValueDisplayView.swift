//
//  KeyValueCountView.swift
//  DevFriends
//
//  Created by 유승원 on 2022/11/14.
//

import UIKit
import SnapKit

final class KeyValueDisplayView: UIView {
    private let fontSize = 12
    
    lazy var mainStackView: UIStackView = {
        let mainStackView = UIStackView()
        mainStackView.axis = .horizontal
        mainStackView.spacing = 5
        return mainStackView
    }()
    lazy var keyTitleLabel: UILabel = {
        let keyTitleLabel = UILabel()
        keyTitleLabel.font = .systemFont(ofSize: 12)
        keyTitleLabel.textColor = UIColor(red: 0.792, green: 0.792, blue: 0.792, alpha: 1)
        keyTitleLabel.text = "타이틀"
        keyTitleLabel.sizeToFit()
        return keyTitleLabel
    }()
    lazy var valueLabel: UILabel = {
        let valueLabel = UILabel()
        valueLabel.font = .systemFont(ofSize: 12)
        valueLabel.textColor = UIColor(red: 0.792, green: 0.792, blue: 0.792, alpha: 1)
        valueLabel.text = "개수"
        valueLabel.sizeToFit()
        return valueLabel
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configure()
    }
    
    private func configure() {
        addSubview(mainStackView)
        mainStackView.addArrangedSubview(keyTitleLabel)
        mainStackView.addArrangedSubview(valueLabel)
        mainStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(keyTitleLabel)
        }
    }
    
    func set(title: String, value: String) {
        keyTitleLabel.text = title
        valueLabel.text = value
    }
}
