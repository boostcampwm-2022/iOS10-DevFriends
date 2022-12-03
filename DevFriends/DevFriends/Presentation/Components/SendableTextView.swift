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
    private let textField = UITextField()
    
    private let sendButton: UIButton = {
        let button = UIButton()
        button.setImage(.sendable, for: .normal)
        button.imageView?.tintColor = .orange
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
                    self?.makeSendButton()
                } else {
                    self?.removeSendButton()
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
    
    func removeSendButton() {
        self.sendButton.snp.updateConstraints { make in
            make.width.equalTo(0)
        }
    }
    
    func makeSendButton() {
        self.sendButton.snp.updateConstraints { make in
            make.width.equalTo(60)
        }
    }
    
    func layout() {
        self.addSubview(sendButton)
        self.sendButton.snp.makeConstraints { make in
            make.height.equalTo(60)
            make.width.equalTo(0)
            make.bottom.equalToSuperview()
            make.trailing.equalToSuperview().offset(-10)
        }
        
        self.addSubview(textField)
        self.textField.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.top.bottom.equalToSuperview()
            make.trailing.equalTo(sendButton.snp.leading).offset(-10)
        }
    }
}
