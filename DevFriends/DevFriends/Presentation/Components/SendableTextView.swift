//
//  SendableTextView.swift
//  DevFriends
//
//  Created by 심주미 on 2022/11/16.
//

import Combine
import UIKit
import Kingfisher

protocol SendableTextViewDelegate: AnyObject {
    func tapSendButton(text: String)
}

final class SendableTextView: UIView {
    private lazy var textField: UITextField = {
        let textField = UITextField()
        self.addSubview(textField)
        return textField
    }()
    
    private lazy var sendButton: UIButton = {
        let button = UIButton()
        button.setImage(.sendable, for: .normal)
        button.imageView?.tintColor = .orange
        self.addSubview(button)
        return button
    }()
    
    weak var delegate: SendableTextViewDelegate?
    
    private var cancellables = Set<AnyCancellable>()
    
    init(placeholder: String?) {
        super.init(frame: .zero)
        self.textField.placeholder = placeholder
        self.layout()
        self.bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind() {
        self.textField.textPublisher
            .sink { [weak self] text in
                if let text = text, !text.isEmpty {
                    self?.makeSendButtonWidthConstraintsOffset()
                } else {
                    self?.removeSendButtonWidthConstraintsOffset()
                }
            }
            .store(in: &cancellables)
        
        self.sendButton.publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                if let text = self?.textField.text {
                    self?.delegate?.tapSendButton(text: text)
                    self?.textField.text = nil
                }
            }
            .store(in: &cancellables)
    }
    
    func removeSendButtonWidthConstraintsOffset() {
        self.sendButton.snp.updateConstraints {
            $0.width.equalTo(0)
        }
    }
    
    func makeSendButtonWidthConstraintsOffset() {
        self.sendButton.snp.updateConstraints {
            $0.width.equalTo(60)
        }
    }
    
    func layout() {
        self.sendButton.snp.makeConstraints {
            $0.height.equalTo(60)
            $0.width.equalTo(0)
            $0.bottom.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-10)
        }
        
        self.textField.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.top.bottom.equalToSuperview()
            $0.trailing.equalTo(sendButton.snp.leading).offset(-10)
        }
    }
}
