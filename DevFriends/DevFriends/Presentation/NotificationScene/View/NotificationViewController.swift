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
    private let tempNotifications = [Notification(image: nil, title: "서울숲에서 모각코합니다!", subTitle: "내일 모임이 예정되어있어요!"), Notification(image: nil, title: "C언어 공부하실 분!!", subTitle: "모임에 가입되었습니다.")]
    
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
