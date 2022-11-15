//
//  ChatViewController.swift
//  DevFriends
//
//  Created by 심주미 on 2022/11/14.
//

import UIKit
import SnapKit

class ChatViewController: ViewController {
    
    private lazy var chatTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ChatTableViewCell.self, forCellReuseIdentifier: ChatTableViewCell.reuseIdentifier)
        self.view.addSubview(tableView)
        return tableView
    }()
    
    private lazy var chatTableViewDiffableDataSource = UITableViewDiffableDataSource<Section, Group>(tableView: chatTableView) { tableView, indexPath, data -> UITableViewCell in
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ChatTableViewCell.reuseIdentifier, for: indexPath) as? ChatTableViewCell else {
            return UITableViewCell()
        }
        cell.updateContent(data: data, lastContent: "", hasNewMessage: true)
        return cell
    }
    
    lazy var chatTableViewSnapShot = NSDiffableDataSourceSnapshot<Section, Group>()
    
    override func configureUI() {
        self.setupTableView()
    }
    
    override func layout() {
        chatTableView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    
    private func setupTableView() {
        self.chatTableViewSnapShot.appendSections([.main])
    }
    
    private func populateSnapshot(data: [Group]) {
        self.chatTableViewSnapShot.appendItems(data)
        self.chatTableViewDiffableDataSource.apply(chatTableViewSnapShot, animatingDifferences: true)
    }
}
