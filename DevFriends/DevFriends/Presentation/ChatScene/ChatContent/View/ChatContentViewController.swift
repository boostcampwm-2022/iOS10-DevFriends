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
        tableView.separatorStyle = .none
        tableView.register(
            FriendMessageTableViewCell.self,
            forCellReuseIdentifier: FriendMessageTableViewCell.reuseIdentifier
        )
        tableView.register(
            MyMessageTableViewCell.self,
            forCellReuseIdentifier: MyMessageTableViewCell.reuseIdentifier
        )
        return tableView
    }()
    
    private lazy var messageTableViewDiffableDataSource = {
        let diffableDataSource = UITableViewDiffableDataSource<Section, Message>(
            tableView: messageTableView
        ) { tableView, indexPath, data -> UITableViewCell in
            if data.userID == UserDefaults.standard.object(forKey: "uid") as? String {
                let cell = self.createMyMessageTableViewCell(
                    tableView: tableView,
                    indexPath: indexPath,
                    data: data
                ) ?? UITableViewCell()
                return cell
            } else {
                let cell = self.createFriendMessageTableViewCell(
                    tableView: tableView,
                    indexPath: indexPath,
                    data: data
                ) ?? UITableViewCell()
                return cell
            }
        }
        return diffableDataSource
    }()
    
    private lazy var messageTextField: SendableTextView = {
        let textField = SendableTextView(placeholder: "메세지를 작성해주세요")
        textField.delegate = self
        return textField
    }()
    
    lazy var messageTableViewSnapShot = NSDiffableDataSourceSnapshot<Section, Message>()
    
    private let viewModel: ChatContentViewModel
    
    init(chatContentViewModel: ChatContentViewModel) {
        self.viewModel = chatContentViewModel
        
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
        viewModel.messages
            .sink { messages in
                self.populateSnapshot(data: messages)
                
                DispatchQueue.main.async {
                    self.messageTableView.reloadData()
                    
                    if !messages.isEmpty {
                        let indexPath = IndexPath(row: messages.count - 1, section: 0)
                        self.messageTableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    override func configureUI() {
        self.setupTableView()
    }
    
    private func setupTableView() {
        self.messageTableViewSnapShot.appendSections([.main])
        viewModel.didLoadMessages()
    }
    
    private func createMyMessageTableViewCell(tableView: UITableView, indexPath: IndexPath, data: Message) -> MyMessageTableViewCell? {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: MyMessageTableViewCell.reuseIdentifier,
            for: indexPath
        ) as? MyMessageTableViewCell else { return nil }
        
        cell.updateContent(data: data)
        if self.isNoNeedToHaveTimeLabel(data: data, indexPath: indexPath) {
            cell.removeTimeLabel()
        }
        
        return cell
    }
    
    private func createFriendMessageTableViewCell(tableView: UITableView, indexPath: IndexPath, data: Message) -> FriendMessageTableViewCell? {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: FriendMessageTableViewCell.reuseIdentifier,
            for: indexPath
        ) as? FriendMessageTableViewCell else {
            return nil
        }
        
        cell.updateContent(data: data)
        if self.isNoNeedToHaveTimeLabel(data: data, indexPath: indexPath) {
            cell.removeTimeLabel()
        }
        
        if self.isNoNeedToHaveProfileInfo(data: data, indexPath: indexPath) {
            cell.removeProfileAndName()
        }
        
        return cell
    }
    
    private func isNoNeedToHaveTimeLabel(data: Message, indexPath: IndexPath) -> Bool {
        guard indexPath.row + 1 != self.viewModel.messages.value.count else { return false }
        let isSameTime = data.time.isSame(as: self.viewModel.messages.value[indexPath.row + 1].time)
        return isSameTime
    }
    
    private func isNoNeedToHaveProfileInfo(data: Message, indexPath: IndexPath) -> Bool {
        guard indexPath.row - 1 >= 0 else { return false }
        let isSameUser = data.userID == self.viewModel.messages.value[indexPath.row - 1].userID
        return isSameUser
    }
    
    private func populateSnapshot(data: [Message]) {
        self.messageTableViewSnapShot.appendItems(data)
        self.messageTableViewDiffableDataSource.apply(messageTableViewSnapShot, animatingDifferences: true)
    }
}

extension ChatContentViewController: SendableTextViewDelegate {
    func tapSendButton(text: String) {
        viewModel.didSendMessage(text: text)
    }
}
