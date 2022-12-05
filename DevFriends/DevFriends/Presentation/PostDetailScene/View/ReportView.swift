//
//  ReportView.swift
//  DevFriends
//
//  Created by 유승원 on 2022/11/15.
//

import UIKit

final class ReportView: UIView {
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
    private let textView: UITextView = {
        let textView = UITextView()
        textView.layer.cornerRadius = 5
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.devFriendsGray.cgColor
        textView.isEditable = true
        return textView
    }()
    private let submitButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .devFriendsOrange
        button.setTitle("제출하기", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.layer.cornerRadius = 5
        return button
    }()
    private let closeButton: UIButton = {
        let button = UIButton()
        button.setTitle("취소", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.devFriendsGray.cgColor
        return button
    }()
    
    required init?(coder: NSCoder) {
        fatalError("Init Error")
    }
    
    init() {
        super.init(frame: .zero)
        
        self.layout()
    }
    
    private func layout() {
        self.addSubview(stackView)
        self.stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.stackView.addArrangedSubview(titleLabel)
        
        self.stackView.addArrangedSubview(textView)
        self.stackView.setCustomSpacing(20, after: titleLabel)
        self.textView.snp.makeConstraints { make in
            make.height.equalTo(130)
        }
        
        self.stackView.addArrangedSubview(submitButton)
        self.stackView.setCustomSpacing(30, after: textView)
        submitButton.snp.makeConstraints { make in
            make.height.equalTo(48)
        }
        
        self.stackView.addArrangedSubview(closeButton)
        self.stackView.setCustomSpacing(10, after: submitButton)
        self.closeButton.snp.makeConstraints { make in
            make.height.equalTo(48)
        }
    }
    
    func setTitleText(title: String) {
        self.titleLabel.text = title
    }
}
