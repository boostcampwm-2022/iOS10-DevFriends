//
//  MyGroupsViewController.swift
//  DevFriends
//
//  Created by 심주미 on 2022/11/23.
//

import Combine
import UIKit

final class MyGroupsViewController: UIViewController {
    private lazy var backBarButton: UIBarButtonItem = {
        let barButton = UIBarButtonItem()
        barButton.image = .chevronLeft
        barButton.style = .plain
        barButton.tintColor = .black
        return barButton
    }()
    
    private lazy var groupCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: compositionalLayout)
        collectionView.backgroundColor = .white
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(cellType: MyGroupCollectionViewCell.self)
        collectionView.delegate = self
        return collectionView
    }()

    private lazy var compositionalLayout: UICollectionViewCompositionalLayout = {
        let layout = UICollectionViewCompositionalLayout() { sectionIndex, layoutEnvironment in
            var config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
            config.trailingSwipeActionsConfigurationProvider = self.makeSwipeActions
            
            let section = NSCollectionLayoutSection.list(using: config, layoutEnvironment: layoutEnvironment)
            section.contentInsets.leading = 5
            section.contentInsets.trailing = 5
            section.contentInsets.top = 5
            section.contentInsets.bottom = 5
            section.interGroupSpacing = 10
            
            return section
        }
        
        return layout
    }()
    
    private lazy var groupCollectionViewDiffableDataSource = UICollectionViewDiffableDataSource<Section, Group>(
        collectionView: groupCollectionView) { collectionView, indexPath, data in
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MyGroupCollectionViewCell.reuseIdentifier,
            for: indexPath) as? MyGroupCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.set(data)
        return cell
    }
    
    private var groupCollectionViewSnapShot = NSDiffableDataSourceSnapshot<Section, Group>()
    
    private var cancellables = Set<AnyCancellable>()
    
    let viewModel: MyGroupsViewModel
    
    init(viewModel: MyGroupsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        viewModel.didLoadGroup()
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
    
    private func configureUI() {
        setupCollectionView()
        setupNavigation()
    }
    
    func setupNavigation() {
        navigationItem.leftBarButtonItems = [backBarButton]
        navigationItem.title = viewModel.getMyGroupsType().rawValue
    }
    
    private func setupCollectionView() {
        groupCollectionViewSnapShot.appendSections([.main])
    }
    
    private func populateSnapshot(data: [Group]) {
        groupCollectionViewSnapShot.deleteAllItems()
        setupCollectionView()
        
        groupCollectionViewSnapShot.appendItems(data)
        groupCollectionViewDiffableDataSource.apply(groupCollectionViewSnapShot)
    }
    
    private func layout() {
        view.addSubview(groupCollectionView)
        groupCollectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func bind() {
        backBarButton.publisher
            .sink { [weak self] _ in
                self?.didTouchedBackButton()
            }
            .store(in: &cancellables)
        
        viewModel.groupsSubject
            .sink { [weak self] groups in
                self?.populateSnapshot(data: groups)
            }
            .store(in: &cancellables)
    }
    
    private func didTouchedBackButton() {
        viewModel.didTouchedBackButton()
    }
    
    private func makeSwipeActions(for indexPath: IndexPath?) -> UISwipeActionsConfiguration? {
        let deleteActionTitle: String
        let deleteAction: UIContextualAction
        
        let type = viewModel.getMyGroupsType()
        switch type {
        case .makedGroup:
            return UISwipeActionsConfiguration(actions: [])
        case .participatedGroup:
            guard let indexPath = indexPath else { return nil }
            let group = viewModel.groupsSubject.value[indexPath.item]
            
            deleteActionTitle = NSLocalizedString("나가기", comment: "Delete action title")
            deleteAction = UIContextualAction(style: .destructive, title: deleteActionTitle) { [weak self] _, _, _ in
                self?.viewModel.didLeaveGroup(group: group)
            }
        case .likedGroup:
            return UISwipeActionsConfiguration(actions: [])
        }

        let config = UISwipeActionsConfiguration(actions: [deleteAction])
        config.performsFirstActionWithFullSwipe = false
        
        return config
    }
}

extension MyGroupsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let group = viewModel.groupsSubject.value[indexPath.item]
        viewModel.didTapGroup(group: group)
    }
}
