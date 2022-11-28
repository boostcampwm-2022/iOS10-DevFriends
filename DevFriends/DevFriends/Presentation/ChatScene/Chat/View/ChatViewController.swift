//
//  ChatViewController.swift
//  DevFriends
//
//  Created by 심주미 on 2022/11/14.
//

import Combine
import SnapKit
import UIKit

final class ChatViewController: DefaultViewController {
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "채팅"
        label.font = .systemFont(ofSize: 25, weight: .bold)
        return label
    }()
    
    private lazy var chatTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ChatTableViewCell.self, forCellReuseIdentifier: ChatTableViewCell.reuseIdentifier)
        tableView.delegate = self
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private lazy var chatTableViewDiffableDataSource = UITableViewDiffableDataSource<Section, Group>(
        tableView: chatTableView
    ) { tableView, indexPath, data -> UITableViewCell in
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ChatTableViewCell.reuseIdentifier,
            for: indexPath
        ) as? ChatTableViewCell else {
            return UITableViewCell()
        }
        cell.set(data: data, lastMessage: "", hasNewMessage: false)
        return cell
    }
    
    private lazy var chatTableViewSnapShot = NSDiffableDataSourceSnapshot<Section, Group>()
    private let viewModel: ChatViewModel
    
    init(chatViewModel: ChatViewModel) {
        self.viewModel = chatViewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureUI() {
        self.setupTableView()
        self.setupNavigation()
    }
    
    override func layout() {
        self.view.addSubview(chatTableView)
        chatTableView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    
    override func bind() {
        viewModel.groupsSubject
            .receive(on: RunLoop.main)
            .sink { groups in
                self.populateSnapshot(data: groups)
                if !groups.isEmpty {
                    let indexPath = IndexPath(row: groups.count - 1, section: 0)
                    self.chatTableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
                }
            }
            .store(in: &cancellables)
    }
    
    private func setupTableView() {
        self.chatTableViewSnapShot.appendSections([.main])
        viewModel.didLoadGroups()
    }
    
    private func populateSnapshot(data: [Group]) {
        self.chatTableViewSnapShot.appendItems(data)
        self.chatTableViewDiffableDataSource.apply(chatTableViewSnapShot, animatingDifferences: true)
    }
    
    private func setupNavigation() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleLabel)
    }
}

extension ChatViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.didSelectGroup(at: indexPath.row)
    }
}
