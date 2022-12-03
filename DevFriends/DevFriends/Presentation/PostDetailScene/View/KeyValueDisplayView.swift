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
    
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 5
        return stackView
    }()
    private let keyTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .devFriendsGray
        label.text = "타이틀"
        label.sizeToFit()
        return label
    }()
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .devFriendsGray
        label.text = "개수"
        label.sizeToFit()
        return label
    }()
    
    required init?(coder: NSCoder) {
        fatalError("Init Error")
    }
    
    init() {
        super.init(frame: .zero)
        
        self.layout()
    }
    
    private func layout() {
        self.addSubview(mainStackView)
        self.mainStackView.addArrangedSubview(keyTitleLabel)
        self.mainStackView.addArrangedSubview(valueLabel)
        self.mainStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(keyTitleLabel)
        }
    }
    
    func set(title: String, value: String) {
        self.keyTitleLabel.text = title
        self.valueLabel.text = value
    }
}
