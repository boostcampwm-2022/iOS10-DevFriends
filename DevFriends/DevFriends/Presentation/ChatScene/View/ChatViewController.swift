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
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        return tableView
    }()
    
    lazy var chatTableViewDiffableDataSource = UITableViewDiffableDataSource<Section, String>(tableView: chatTableView) { tableView, indexPath, data -> UITableViewCell in
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ChatTableViewCell.reuseIdentifier, for: indexPath) as? ChatTableViewCell else {
            return UITableViewCell()
        }
        cell.backgroundColor = .blue
        return cell
    }
    
    lazy var chatTableViewSnapShot = NSDiffableDataSourceSnapshot<Section, String>()
    
    override func configureUI() {
        setupTableView()
    }
    
    func setupTableView() {
        chatTableViewSnapShot.appendSections([.main])
    }
    
    func populateSnapshot(data: [String]) {
        chatTableViewSnapShot.appendItems(data)
        chatTableViewDiffableDataSource.apply(chatTableViewSnapShot, animatingDifferences: true)
    }
}
