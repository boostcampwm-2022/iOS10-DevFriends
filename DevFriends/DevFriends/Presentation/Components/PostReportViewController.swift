//
//  PostReportViewController.swift
//  DevFriends
//
//  Created by 유승원 on 2022/11/15.
//

import Combine
import UIKit
import SnapKit

struct PostReportViewControllerActions {
    let submit: () -> Void
    let close: () -> Void
}

final class PostReportViewController: UIViewController {
    let backBarButtonItem = BackBarButtonItem()
    
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
    
    let actions: PostReportViewControllerActions
    
    var cancellables = Set<AnyCancellable>()
    
    init(actions: PostReportViewControllerActions) {
        self.actions = actions
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.layout()
        self.configureUI()
        self.bind()
    }
    
    private func layout() {
        let containerView = UIView()
        view.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.left.equalTo(view.safeAreaLayoutGuide).offset(14)
            make.right.equalTo(view.safeAreaLayoutGuide).offset(-14)
        }
        
        containerView.addSubview(stackView)
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
        
        self.stackView.setCustomSpacing(10, after: submitButton)
    }
    
    private func configureUI() {
        self.titleLabel.text = "신고하려는 이유가 무엇인가요?"
        self.navigationItem.leftBarButtonItem = backBarButtonItem
    }
    
    private func bind() {
        submitButton.publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                self?.actions.submit()
            }
            .store(in: &cancellables)
        
        backBarButtonItem.publisher
            .sink { [weak self] _ in
                self?.actions.close()
            }
            .store(in: &cancellables)
    }
}
