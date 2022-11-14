//
//  ChatViewController.swift
//  DevFriends
//
//  Created by 심주미 on 2022/11/14.
//

import UIKit
import SnapKit

class ChatViewController: ViewController {
    
    lazy var chatTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ChatTableViewCell.self, forCellReuseIdentifier: ChatTableViewCell.reuseIdentifier)
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
        }
        return tableView
    }()
    
    lazy var chatTableViewDiffableDataSource = UITableViewDiffableDataSource<Section, Group>(tableView: chatTableView) { tableView, indexPath, data -> UITableViewCell in
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ChatTableViewCell.reuseIdentifier, for: indexPath) as? ChatTableViewCell else {
            return UITableViewCell()
        }
        cell.updateContent(data: data, lastContent: "", hasNewMessage: false)
        return cell
    }
    
    lazy var chatTableViewSnapShot = NSDiffableDataSourceSnapshot<Section, Group>()
    
    override func configureUI() {
        self.setupTableView()
    }
    
    func setupTableView() {
        self.chatTableViewSnapShot.appendSections([.main])
    }
    
    func populateSnapshot(data: [Group]) {
        self.chatTableViewSnapShot.appendItems(data)
        self.chatTableViewDiffableDataSource.apply(chatTableViewSnapShot, animatingDifferences: true)
    }
}
