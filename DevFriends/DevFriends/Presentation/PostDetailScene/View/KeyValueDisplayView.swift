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
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 5
        return stackView
    }()
    private lazy var keyTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = UIColor(red: 0.792, green: 0.792, blue: 0.792, alpha: 1)
        label.text = "타이틀"
        label.sizeToFit()
        return label
    }()
    private lazy var valueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = UIColor(red: 0.792, green: 0.792, blue: 0.792, alpha: 1)
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
