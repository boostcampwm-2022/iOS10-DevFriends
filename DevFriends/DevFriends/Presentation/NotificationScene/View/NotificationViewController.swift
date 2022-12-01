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
        let diffableDataSource = NotificationDiffableDataSource(
            tableView: self.tableView
        ) { tableView, indexPath, data in
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: NotificationTableViewCell.reuseIdentifier,
                for: indexPath
            ) as? NotificationTableViewCell else { return UITableViewCell() }
            cell.selectionStyle = .none
            cell.updateContent(data: data)
            cell.acceptButton
                .publisher(for: .touchUpInside)
                .sink {
                    self.viewModel.didAcceptedParticipant(index: indexPath.row)
                }
                .store(in: &self.cancellables)
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
        self.setupNavigation()
        self.bind()
        self.viewModel.didLoadNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.tabBarController?.tabBar.isHidden = false // TODO: 코디네이터에서 backTo 메서드 구현되면 그 곳에서 사용
    }
    
    private func bind() {
        self.viewModel.notificationsSubject
            .receive(on: RunLoop.main)
            .sink {
                self.populateSnapshot(data: $0)
            }
            .store(in: &cancellables)
        self.notificationDiffableDataSource.notificationSubject
            .sink {
                self.viewModel.didDeleteNotification(of: $0)
            }
            .store(in: &cancellables)
    }
    
    private func setupNavigation() {
        self.navigationItem.title = "알림"
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
