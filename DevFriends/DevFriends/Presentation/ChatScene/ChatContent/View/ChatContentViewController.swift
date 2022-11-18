//
//  ChatContentViewController.swift
//  DevFriends
//
//  Created by 심주미 on 2022/11/15.
//

import Combine
import UIKit

class ChatContentViewController: DefaultViewController {
    private lazy var messageTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(FriendMessageTableViewCell.self, forCellReuseIdentifier: FriendMessageTableViewCell.reuseIdentifier)
        tableView.register(MyMessageTableViewCell.self, forCellReuseIdentifier: MyMessageTableViewCell.reuseIdentifier)
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private lazy var messageTextField: SendableTextView = {
        let textField = SendableTextView(placeholder: "메시지를 작성해주세요")
        textField.delegate = self
        return textField
    }()
    
    private lazy var messageTableViewDiffableDataSource = UITableViewDiffableDataSource<Section, Message>(tableView: messageTableView) { [weak self] tableView, indexPath, data -> UITableViewCell in
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MyMessageTableViewCell.reuseIdentifier, for: indexPath) as? MyMessageTableViewCell else {
            return UITableViewCell()
        }
        cell.set(data: data, messageContentType: .time)
        return cell
    }
    
    lazy var messageTableViewSnapShot = NSDiffableDataSourceSnapshot<Section, Message>()
    
    init(group: Group) {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layout() {
        self.view.addSubview(messageTextField)
        self.messageTextField.snp.makeConstraints { make in
            make.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
            make.bottom.equalTo(self.view.keyboardLayoutGuide.snp.top)
            make.size.height.equalTo(50)
        }
        
        self.view.addSubview(messageTableView)
        self.messageTableView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
            make.bottom.equalTo(self.messageTextField.snp.top)
        }
    }
    
    override func bind() {
        self.hideKeyboardWhenTappedAround()
    }
    
    override func configureUI() {
        self.setupTableView()
    }
    
    private func setupTableView() {
        self.messageTableViewSnapShot.appendSections([.main])
    }
    
    private func populateSnapshot(data: [Message]) {
        self.messageTableViewSnapShot.appendItems(data)
        self.messageTableViewDiffableDataSource.apply(messageTableViewSnapShot, animatingDifferences: true)
    }
}

extension ChatContentViewController: SendableTextViewDelegate {
    func tapSendButton(text: String) {
        print(text, "보냄")
    }
}
