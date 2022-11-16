//
//  ChatContentViewController.swift
//  DevFriends
//
//  Created by 심주미 on 2022/11/15.
//

import UIKit

class ChatContentViewController: ViewController {
    private lazy var messageTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(FriendMessageTableViewCell.self, forCellReuseIdentifier: FriendMessageTableViewCell.reuseIdentifier)
        tableView.register(MyMessageTableViewCell.self, forCellReuseIdentifier: MyMessageTableViewCell.reuseIdentifier)
        self.view.addSubview(tableView)
        return tableView
    }()
    
    private lazy var messageTableViewDiffableDataSource = UITableViewDiffableDataSource<Section, Message>(tableView: messageTableView) { tableView, indexPath, data -> UITableViewCell in
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FriendMessageTableViewCell.reuseIdentifier, for: indexPath) as? FriendMessageTableViewCell else {
            return UITableViewCell()
        }
        cell.updateContent(data: data, messageContentType: .profileAndTime)
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
        self.messageTableView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
        }
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
