//
//  NotificationViewController.swift
//  DevFriends
//
//  Created by 유승원 on 2022/11/21.
//

import UIKit

final class NotificationViewController: UITableViewController {
    private lazy var notificationDiffableDataSource = {
        let diffableDataSource = UITableViewDiffableDataSource<Section, Notification>(
            tableView: tableView
        ) { tableView, indexPath, data in
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: NotificationTableViewCell.reuseIdentifier
            ) as? NotificationTableViewCell else { return UITableViewCell() }
            cell.updateContent(data: data)
            return cell
        }
        return diffableDataSource
    }()
    
    private lazy var notificationTableViewSnapShot = NSDiffableDataSourceSnapshot<Section, Notification>()
    private let tempNotifications = [
        Notification(
            groupID: "abc",
            groupTitle: "서울숲에서 모각코합니다!",
            senderID: "def",
            senderNickname: "빈살만왕세자",
            type: "joinRequest",
            isOK: false
        ),
        Notification(
            groupID: "def",
            groupTitle: "카타르에서 축구를 보면서 코딩합시다",
            type: "joinWait"
        ),
        Notification(
            groupID: "rpg",
            groupTitle: "물구나무 서면 피가 거꾸로 쏠려요",
            type: "joinSuccess"
        )
    ]
    
    override func viewDidLoad() {
        tableView.rowHeight = 72
        setupTableView()
        populateSnapshot(data: tempNotifications)
    }
    
    private func setupTableView() {
        tableView.register(
            NotificationTableViewCell.self,
            forCellReuseIdentifier: NotificationTableViewCell.reuseIdentifier
        )
        self.notificationTableViewSnapShot.appendSections([.main])
    }
    
    private func populateSnapshot(data: [Notification]) {
        self.notificationTableViewSnapShot.appendItems(data)
        self.notificationDiffableDataSource.apply(self.notificationTableViewSnapShot, animatingDifferences: true)
    }
}
