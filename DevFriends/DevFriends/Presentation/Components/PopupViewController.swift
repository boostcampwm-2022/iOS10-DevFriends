//
//  PopupViewController.swift
//  DevFriends
//
//  Created by 심주미 on 2022/11/22.
//

import UIKit

struct Popup {
    let title: String
    let message: String
    let done: String
    let close: String
    
    init(title: String, message: String, done: String = "확인", close: String = "닫기") {
        self.title = title
        self.message = message
        self.done = done
        self.close = close
    }
}

class PopupViewController: DefaultViewController {
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "제목"
        label.font = .systemFont(ofSize: 20)
        return label
    }()
    
    private var messageLabel: UILabel = {
        let label = UILabel()
        label.text = "메시지"
        label.font = .systemFont(ofSize: 15)
        label.numberOfLines = 0
        return label
    }()
    
    private var doneButton: CommonButton = {
        let button = CommonButton(text: "확인", type: .fill)
        return button
    }()
    
    private var closeButton: CommonButton = {
        let button = CommonButton(text: "닫기", type: .none)
        return button
    }()
    
    private var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        return view
    }()
    
    func set(popup: Popup) {
        titleLabel.text = popup.title
        messageLabel.text = popup.message
        doneButton.setTitle(popup.done, for: .normal)
        closeButton.setTitle(popup.close, for: .normal)
    }
    
    override func configureUI() {
        view.backgroundColor = .black.withAlphaComponent(0.2)
    }
    
    override func bind() {
        doneButton.publisher(for: .touchUpInside)
            .sink {
                print("doneButton")
            }
            .store(in: &cancellables)
        
        closeButton.publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                print("closeButton")
                self?.dismiss(animated: false)
            }
            .store(in: &cancellables)
    }
    
    override func layout() {
        view.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(50)
            make.trailing.equalToSuperview().offset(-50)
        }
        
        containerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        containerView.addSubview(messageLabel)
        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.trailing.equalTo(titleLabel)
        }
        
        containerView.addSubview(doneButton)
        doneButton.snp.makeConstraints { make in
            make.top.equalTo(messageLabel.snp.bottom).offset(20)
            make.leading.trailing.equalTo(titleLabel)
        }
        
        containerView.addSubview(closeButton)
        closeButton.snp.makeConstraints { make in
            make.top.equalTo(doneButton.snp.bottom).offset(5)
            make.leading.trailing.equalTo(titleLabel)
            make.bottom.equalToSuperview().offset(-20)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseOut) {
            self.containerView.transform = .identity
            self.containerView.isHidden = false
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseIn) {
            self.containerView.transform = .identity
            self.containerView.isHidden = true
        }
    }
}
