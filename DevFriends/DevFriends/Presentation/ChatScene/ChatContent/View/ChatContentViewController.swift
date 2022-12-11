//
//  ChatContentViewController.swift
//  DevFriends
//
//  Created by 심주미 on 2022/11/15.
//

import Combine
import UIKit

class ChatContentViewController: UIViewController {
    private let backBarButton = BackBarButtonItem()
    private let settingButton = SettingBarButtonItem()
    
    private lazy var messageTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.register(cellType: FriendMessageTableViewCell.self)
        tableView.register(cellType: MyMessageTableViewCell.self)
        tableView.register(cellType: DateTableViewCell.self)
        return tableView
    }()
    
    private lazy var messageTableViewDiffableDataSource: UITableViewDiffableDataSource<Section, AnyHashable> = {
        let diffableDataSource = UITableViewDiffableDataSource<Section, AnyHashable>(
            tableView: messageTableView
        ) { [weak self] tableView, indexPath, data -> UITableViewCell in
            if let data = data as? Message {
                if data.userID == UserManager.shared.uid {
                    let cell = self?.createMyMessageTableViewCell(
                        tableView: tableView,
                        indexPath: indexPath,
                        data: data
                    ) ?? UITableViewCell()
                    cell.selectionStyle = .none
                    return cell
                } else {
                    let cell = self?.createFriendMessageTableViewCell(
                        tableView: tableView,
                        indexPath: indexPath,
                        data: data
                    ) ?? UITableViewCell()
                    cell.selectionStyle = .none
                    return cell
                }
            } else if let data = data as? DateMessage {
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: DateTableViewCell.reuseIdentifier
                ) as? DateTableViewCell else { return UITableViewCell() }
                cell.set(date: data.time)
                return cell
            }
            return UITableViewCell()
        }
        return diffableDataSource
    }()
    
    private let messageTextField = SendableTextView(placeholder: "메세지를 작성해주세요")
    
    private lazy var messageTableViewSnapShot = NSDiffableDataSourceSnapshot<Section, AnyHashable>()
    
    private let viewModel: ChatContentViewModel
    
    init(chatContentViewModel: ChatContentViewModel) {
        self.viewModel = chatContentViewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
        self.layout()
        self.bind()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.viewWillDisappear()
    }
    
    private func layout() {
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
    
    private func bind() {
        let gesture = UITapGestureRecognizer()
        messageTableView.gesturePublisher(.tap(gesture))
            .sink { [weak self] _ in
                self?.view.endEditing(true)
                gesture.cancelsTouchesInView = false
            }
            .store(in: &cancellables)
        
        settingButton.publisher
            .sink { [weak self] _ in
                self?.didTapSettingButton()
            }
            .store(in: &cancellables)
        
        backBarButton.publisher
            .sink { [weak self] _ in
                self?.viewModel.back()
            }
            .store(in: &cancellables)
        
        viewModel.messagesSubject
            .receive(on: RunLoop.main)
            .sink { [weak self] messages in
                self?.populateSnapshot(data: messages)
                
                if !messages.isEmpty {
                    let indexPath = IndexPath(row: messages.count - 1, section: 0)
                    self?.messageTableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
                }
            }
            .store(in: &cancellables)
        
        messageTextField.tapSendButtonSubject
            .sink { [weak self] text in
                self?.viewModel.didSendMessage(text: text)
            }
            .store(in: &cancellables)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(scrollToBottom),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
    }
    
    @objc func scrollToBottom() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            if self.viewModel.getCurrentMessageCount() == 0 {
                return
            }
            let lastIndexPath = IndexPath(row: self.viewModel.getCurrentMessageCount() - 1, section: 0)
            self.messageTableView.scrollToRow(at: lastIndexPath, at: .bottom, animated: true)
        }
    }
    
    private func configureUI() {
        self.view.backgroundColor = .devFriendsReverseBase
        self.setupTableView()
        self.setupNavigation()
    }
    
    private func setupTableView() {
        self.messageTableViewSnapShot.appendSections([.main])
        viewModel.didLoadMessages()
    }
    
    private func setupNavigation() {
        self.navigationItem.title = "\(viewModel.group.title)"
        self.navigationItem.leftBarButtonItem = backBarButton
        self.navigationItem.rightBarButtonItem = settingButton
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
        guard indexPath.row + 1 != self.viewModel.messagesSubject.value.count else { return false }
        if let message = self.viewModel.messagesSubject.value[indexPath.row + 1] as? Message {
            let isSameTime = data.time.isSameTime(as: message.time)
            return isSameTime
        }
        return false
    }
    
    private func isNoNeedToHaveProfileInfo(data: Message, indexPath: IndexPath) -> Bool {
        guard indexPath.row - 1 >= 0 else { return false }
        if let message = self.viewModel.messagesSubject.value[indexPath.row - 1] as? Message {
            let isSameUser = data.userID == message.userID
            return isSameUser
        }
        return false
    }
    
    private func populateSnapshot(data: [AnyHashable]) {
        self.messageTableViewSnapShot.appendItems(data)
        self.messageTableViewDiffableDataSource.apply(messageTableViewSnapShot, animatingDifferences: true)
    }
    
    private func didTapSettingButton() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let reportAction = UIAlertAction(title: "신고", style: .default) { [weak self] _ in
            self?.viewModel.didTapSettingButton()
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        
        actionSheet.addAction(reportAction)
        actionSheet.addAction(cancelAction)
        
        present(actionSheet, animated: true)
    }
}
