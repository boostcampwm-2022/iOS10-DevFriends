//
//  ChatViewController.swift
//  DevFriends
//
//  Created by 심주미 on 2022/11/14.
//

import Combine
import SnapKit
import UIKit

final class ChatViewController: UIViewController {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "채팅"
        label.font = .systemFont(ofSize: 25, weight: .bold)
        return label
    }()
    
    private lazy var chatTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(cellType: ChatTableViewCell.self)
        tableView.delegate = self
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private lazy var chatTableViewDiffableDataSource = UITableViewDiffableDataSource<Section, AcceptedGroup>(
        tableView: chatTableView
    ) { tableView, indexPath, data -> UITableViewCell in
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ChatTableViewCell.reuseIdentifier,
            for: indexPath
        ) as? ChatTableViewCell else {
            return UITableViewCell()
        }
        cell.set(data: data)
        return cell
    }
    
    private lazy var chatTableViewSnapShot = NSDiffableDataSourceSnapshot<Section, AcceptedGroup>()
    
    private var cancellables = Set<AnyCancellable>()
    
    private let viewModel: ChatViewModel
    
    init(chatViewModel: ChatViewModel) {
        self.viewModel = chatViewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
        self.layout()
        self.bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewWillAppear()
    }
    
    private func configureUI() {
        self.setupTableView()
        self.setupNavigation()
    }
    
    private func layout() {
        self.view.addSubview(chatTableView)
        chatTableView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    
    private func bind() {
        viewModel.groupsSubject
            .receive(on: RunLoop.main)
            .sink { [weak self] groups in
                self?.populateSnapshot(data: groups)
                if self?.chatTableView.numberOfRows(inSection: 0) ?? 0 > 0 {
                    self?.chatTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
                }
            }
            .store(in: &cancellables)
    }
    
    private func setupTableView() {
        self.chatTableViewSnapShot.appendSections([.main])
        viewModel.didLoadGroups()
    }
    
    private func populateSnapshot(data: [AcceptedGroup]) {
        self.chatTableViewSnapShot.deleteAllItems()
        self.chatTableViewSnapShot.appendSections([.main])
        self.chatTableViewSnapShot.appendItems(data)
        self.chatTableViewDiffableDataSource.apply(chatTableViewSnapShot, animatingDifferences: false)
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
