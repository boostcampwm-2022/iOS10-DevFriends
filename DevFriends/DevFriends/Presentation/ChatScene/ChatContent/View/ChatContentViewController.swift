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
    
    private lazy var messageTextField: SendableTextView = {
        let textField = SendableTextView(placeholder: "메시지를 작성해주세요")
        textField.delegate = self
        return textField
    }()
    
    lazy var messageTableViewSnapShot = NSDiffableDataSourceSnapshot<Section, Message>()
    
    var messageTableViewDiffableDataSource: UITableViewDiffableDataSource<Section, Message>?
    
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
            .receive(on: RunLoop.main)
            .sink {
                self.populateSnapshot(data: $0) // MARK: 얘는 메인 스레드에서 안 돌려도 되는데 어떻게 깔끔하게 분리할까?
                self.messageTableView.reloadData()
                
                if !$0.isEmpty {
                    let indexPath = IndexPath(row: $0.count - 1, section: 0)
                    self.messageTableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
                }
            }
            .store(in: &cancellables)
    }
    
    override func configureUI() {
        self.setupTableView()
        self.createDiffableDataSource()
    }
    
    private func setupTableView() {
        self.messageTableViewSnapShot.appendSections([.main])
        viewModel.didLoadMessages()
    }
    
    private func createDiffableDataSource() {
        messageTableViewDiffableDataSource = UITableViewDiffableDataSource<Section, Message>(
            tableView: messageTableView
        ) { tableView, indexPath, data -> UITableViewCell in
            // TODO: 여기서 Friend vs My를 결정하는 로직이 들어가면 안 될듯 -> 추후 수정하기
            if data.userID == UserDefaults.standard.object(forKey: "uid") as? String {
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: MyMessageTableViewCell.reuseIdentifier,
                    for: indexPath
                ) as? MyMessageTableViewCell else {
                    return UITableViewCell()
                }
                cell.updateContent(data: data)
                
                // TODO: 시간을 어떻게 띄울지 말지에 관한 로직을 VC에서 하는 것은 문제가 있음
                if indexPath.row + 1 != self.viewModel.messages.value.count && data.time.isSame(as: self.viewModel.messages.value[indexPath.row + 1].time) {
                    cell.setTimeLabel(isHidden: true)
                }
                return cell
            } else {
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: FriendMessageTableViewCell.reuseIdentifier,
                    for: indexPath
                ) as? FriendMessageTableViewCell else {
                    return UITableViewCell()
                }
                cell.updateContent(data: data, messageContentType: .profileAndTime)
                
                if indexPath.row + 1 != self.viewModel.messages.value.count && data.time.isSame(as: self.viewModel.messages.value[indexPath.row + 1].time) {
                    cell.setTimeLabel(isHidden: true)
                }
                
                if indexPath.row - 1 >= 0 && data.userID == self.viewModel.messages.value[indexPath.row - 1].userID {
                    cell.setProfileAndName(isHidden: true)
                }
                return cell
            }
        }
    }
    
    private func populateSnapshot(data: [Message]) {
        self.messageTableViewSnapShot.appendItems(data)
        self.messageTableViewDiffableDataSource?.apply(messageTableViewSnapShot, animatingDifferences: true)
    }
}

extension ChatContentViewController: SendableTextViewDelegate {
    func tapSendButton(text: String) {
        viewModel.didSendMessage(text: text)
    }
}
