//
//  ChatViewController.swift
//  DevFriends
//
//  Created by 심주미 on 2022/11/14.
//

import UIKit
import SnapKit

final class ChatViewController: DefaultViewController {
    private lazy var chatTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ChatTableViewCell.self, forCellReuseIdentifier: ChatTableViewCell.reuseIdentifier)
        tableView.delegate = self
        self.view.addSubview(tableView)
        return tableView
    }()
    
    private lazy var chatTableViewDiffableDataSource = UITableViewDiffableDataSource<Section, Group>(tableView: chatTableView) { tableView, indexPath, data -> UITableViewCell in
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ChatTableViewCell.reuseIdentifier, for: indexPath) as? ChatTableViewCell else {
            return UITableViewCell()
        }
        cell.updateContent(data: data, lastMessage: "", hasNewMessage: false)
        return cell
    }
    
    private lazy var chatTableViewSnapShot = NSDiffableDataSourceSnapshot<Section, Group>()
    
    weak var coordinator: ChatViewCoordinator?
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureUI() {
        self.setupTableView()
    }
    
    override func layout() {
        chatTableView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
        }
        populateSnapshot(data: [Group(participantIDs: ["12"], title: "d"), Group(participantIDs: ["13"], title: "d"), Group(participantIDs: ["1"], title: "dd")])
    }
    
    private func setupTableView() {
        self.chatTableViewSnapShot.appendSections([.main])
    }
    
    private func populateSnapshot(data: [Group]) {
        self.chatTableViewSnapShot.appendItems(data)
        self.chatTableViewDiffableDataSource.apply(chatTableViewSnapShot, animatingDifferences: true)
    }
}

extension ChatViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        coordinator?.showChatContentViewController(group: Group(participantIDs: ["0"], title: "title"))
    }
}
