//
//  NotificationViewController.swift
//  DevFriends
//
//  Created by 유승원 on 2022/11/21.
//

import Combine
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
    
    private let viewModel: NotificationViewModel
    private var cancellables = Set<AnyCancellable>()
    
    init(notificationViewModel: NotificationViewModel) {
        self.viewModel = notificationViewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = 72
        self.setupTableView()
        self.bind()
        self.viewModel.didLoadNotifications()
    }
    
    private func bind() {
        self.viewModel.notificationsSubject
            .receive(on: RunLoop.main)
            .sink {
                self.populateSnapshot(data: $0)
            }
            .store(in: &cancellables)
    }
    
    private func setupTableView() {
        self.tableView.register(
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
