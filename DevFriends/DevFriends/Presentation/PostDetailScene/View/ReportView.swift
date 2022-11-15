//
//  ReportView.swift
//  DevFriends
//
//  Created by 유승원 on 2022/11/15.
//

import UIKit

final class ReportView: UIView {
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = .boldSystemFont(ofSize: 20)
        return titleLabel
    }()
    lazy var textView: UITextView = {
        let textView = UITextView()
        textView.layer.cornerRadius = 5
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor(red: 0.821, green: 0.804, blue: 0.804, alpha: 1).cgColor
        textView.isEditable = true
        return textView
    }()
    lazy var submitButton: UIButton = {
        let submitButton = UIButton()
        submitButton.backgroundColor = UIColor(red: 0.992, green: 0.577, blue: 0.277, alpha: 1)
        submitButton.setTitle("제출하기", for: .normal)
        submitButton.titleLabel?.font = .systemFont(ofSize: 14)
        submitButton.layer.cornerRadius = 5
        return submitButton
    }()
    lazy var closeButton: UIButton = {
        let closeButton = UIButton()
        closeButton.setTitle("취소", for: .normal)
        closeButton.titleLabel?.font = .systemFont(ofSize: 14)
        closeButton.setTitleColor(.black, for: .normal)
        closeButton.layer.cornerRadius = 5
        closeButton.layer.borderWidth = 1
        closeButton.layer.borderColor = UIColor(red: 0.792, green: 0.792, blue: 0.792, alpha: 1).cgColor
        return closeButton
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        configure()
    }
    
    private func configure() {
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        stackView.addArrangedSubview(titleLabel)
        
        stackView.addArrangedSubview(textView)
        stackView.setCustomSpacing(20, after: titleLabel)
        textView.snp.makeConstraints { make in
            make.height.equalTo(130)
        }
        
        stackView.addArrangedSubview(submitButton)
        stackView.setCustomSpacing(30, after: textView)
        submitButton.snp.makeConstraints { make in
            make.height.equalTo(48)
        }
        
        stackView.addArrangedSubview(closeButton)
        stackView.setCustomSpacing(10, after: submitButton)
        closeButton.snp.makeConstraints { make in
            make.height.equalTo(48)
        }
    }
}
