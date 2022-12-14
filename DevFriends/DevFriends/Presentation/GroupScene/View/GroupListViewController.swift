//
//  GroupListViewController.swift
//  DevFriends
//
//  Created by 상현 on 2022/11/14.
//

import CoreLocation
import Combine
import SnapKit
import UIKit

final class GroupListViewController: UIViewController {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "모임"
        label.font = .systemFont(ofSize: 25, weight: .bold)
        return label
    }()
    
    private lazy var groupAddButton: UIBarButtonItem = {
        let item = UIBarButtonItem()
        item.image = .plus
        item.tintColor = .devFriendsBase
        item.target = self
        item.action = #selector(didTapGroupAddButton)
        return item
    }()
    
    private lazy var notificationButton: UIBarButtonItem = {
        let item = UIBarButtonItem()
        item.image = .bell
        item.tintColor = .devFriendsBase
        item.target = self
        item.action = #selector(didTapNotificationButton)
        return item
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.compositionalLayout)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delegate = self
        collectionView.register(
            GroupCollectionHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: GroupCollectionHeaderView.reuseIdentifier
        )
        collectionView.register(cellType: GroupCollectionViewCell.self)
        return collectionView
    }()
    
    private lazy var collectionViewDiffableDataSource = UICollectionViewDiffableDataSource<GroupListSection, GroupCellInfo> (
        collectionView: self.collectionView) { collectionView, indexPath, data -> UICollectionViewCell? in
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: GroupCollectionViewCell.reuseIdentifier,
            for: indexPath) as? GroupCollectionViewCell else { return UICollectionViewCell() }
            cell.set(data)
        return cell
    }
    
    private var collectionViewSnapShot = NSDiffableDataSourceSnapshot<GroupListSection, GroupCellInfo>()
                                                                                           
    private let compositionalLayout: UICollectionViewCompositionalLayout = {
        let layout = UICollectionViewCompositionalLayout { sectionNumber, _ -> NSCollectionLayoutSection? in
            
            let screenSize = UIScreen.main.bounds.size
            let padding = screenSize.width * 0.05
            
            if sectionNumber == GroupListSection.recommand.rawValue {
                let item = NSCollectionLayoutItem(
                    layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
                )
                item.contentInsets.trailing = padding
                
                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: .init(widthDimension: .fractionalWidth(0.90), heightDimension: .absolute(140)),
                    subitems: [item]
                )
                
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .groupPaging
                section.contentInsets.leading = padding
                section.contentInsets.top = 10
                section.contentInsets.bottom = 10
                
                // Header, Footer 레이아웃
                section.boundarySupplementaryItems = [
                    .init(
                        layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50)),
                        elementKind: UICollectionView.elementKindSectionHeader,
                        alignment: .top
                    )
                ]
                
                return section
            } else {
                let item = NSCollectionLayoutItem(
                    layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
                )
                item.contentInsets.bottom = 10
                
                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(150)),
                    subitems: [item]
                )
                
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets.leading = padding
                section.contentInsets.trailing = padding
                section.contentInsets.top = 10
                section.contentInsets.bottom = 10
                
                // Header, Footer 레이아웃
                section.boundarySupplementaryItems = [
                    .init(
                        layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50)),
                        elementKind: UICollectionView.elementKindSectionHeader,
                        alignment: .top
                    )
                ]
                
                return section
            }
        }
        return layout
    }()
    
    private lazy var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        return locationManager
    }()
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    private let viewModel: GroupListViewModel
    init(viewModel: GroupListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
        self.layout()
        self.bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setting
    
    private func configureUI() {
        self.view.backgroundColor = .systemGray6
        self.setupNavigationBar()
        self.setupCollectionView()
        self.setupCollectionViewHeader(alignType: .newest)
        self.setupNavigation()
        self.setUserLocation()
        self.viewModel.loadUserRecommand()
        self.viewModel.loadGroupList()
    }
    
    private func layout() {
        self.view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    
    private func setUserLocation() {
        locationManager.startUpdatingLocation()
    }
    
    private func setupNavigationBar() {
        let navigationAppearence = UINavigationBarAppearance()
        navigationAppearence.configureWithDefaultBackground()
        self.navigationController?.navigationBar.scrollEdgeAppearance = navigationAppearence
    }
    
    private func setupCollectionView() {
        self.collectionViewSnapShot.appendSections([.recommand, .filtered])
    }
    
    private func setupCollectionViewHeader(alignType: AlignType) {
        self.collectionViewDiffableDataSource.supplementaryViewProvider = {
            [weak self] (collectionView: UICollectionView,
                         _: String,
                         indexPath: IndexPath
            ) -> UICollectionReusableView? in
            guard let self = self else { return UICollectionReusableView() }
            guard let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: GroupCollectionHeaderView.reuseIdentifier,
                for: indexPath) as? GroupCollectionHeaderView else { return UICollectionReusableView() }
            
            if indexPath.section == GroupListSection.recommand.rawValue {
                header.set(title: "추천 모임")
            } else if indexPath.section == GroupListSection.filtered.rawValue {
                header.set(title: "모집중인 모임", filter: alignType, self, #selector(self.didTapFilterButton))
            }
            
            return header
        }
    }
    
    private func reloadCollectionViewHeader(alignType: AlignType) {
        let recommandItem = self.collectionViewSnapShot.itemIdentifiers(inSection: .recommand)
        let filteredItem = self.collectionViewSnapShot.itemIdentifiers(inSection: .filtered)
        self.setupCollectionViewHeader(alignType: alignType)
        self.collectionViewDiffableDataSource = UICollectionViewDiffableDataSource<GroupListSection, GroupCellInfo>(
            collectionView: self.collectionView) { collectionView, indexPath, data -> UICollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: GroupCollectionViewCell.reuseIdentifier,
                for: indexPath) as? GroupCollectionViewCell else { return UICollectionViewCell() }
                cell.set(data)
            return cell
        }
        self.collectionViewSnapShot = NSDiffableDataSourceSnapshot<GroupListSection, GroupCellInfo>()
        self.setupCollectionView()
        self.setupCollectionViewHeader(alignType: alignType)
        self.collectionViewSnapShot.appendItems(recommandItem, toSection: .recommand)
        self.collectionViewSnapShot.appendItems(filteredItem, toSection: .filtered)
        self.collectionViewDiffableDataSource.apply(collectionViewSnapShot, animatingDifferences: false)
    }
    
    private func populateSnapShot(data: [GroupCellInfo], to section: GroupListSection) {
        let oldItem = self.collectionViewSnapShot.itemIdentifiers(inSection: section)
        self.collectionViewSnapShot.deleteItems(oldItem)
        self.collectionViewSnapShot.appendItems(data, toSection: section)
        self.collectionViewDiffableDataSource.apply(collectionViewSnapShot, animatingDifferences: true)
    }
    
    private func setupNavigation() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleLabel)
        self.navigationItem.rightBarButtonItems = [notificationButton, groupAddButton]
    }
    
    private func bind() {
        viewModel.recommandGroupsSubject
            .receive(on: RunLoop.main)
            .sink { [weak self] groupList in
                self?.populateSnapShot(data: groupList, to: .recommand)
            }
            .store(in: &cancellables)
        
        viewModel.filteredGroupsSubject
            .receive(on: RunLoop.main)
            .sink { [weak self] groupList in
                self?.populateSnapShot(data: groupList, to: .filtered)
            }
            .store(in: &cancellables)
        
        viewModel.filteredGroupAlignTypeSubject
            .receive(on: RunLoop.main)
            .sink { [weak self] updatedType in
                if let self = self {
                    self.reloadCollectionViewHeader(alignType: updatedType)
                }
            }
            .store(in: &cancellables)
    }
}

// MARK: - Actions

extension GroupListViewController {
    @objc func didTapFilterButton(_ sender: UIButton) {
        viewModel.didSelectFilter()
    }
    
    @objc func didTapGroupAddButton(_ sender: UIButton) {
        let actionSheet = UIAlertController(
            title: "모임 종류 선택",
            message: "어떤 모임을 추가하시겠습니까?",
            preferredStyle: .actionSheet
        )
        
        let actionProject = UIAlertAction(title: "프로젝트", style: .default) { [weak self] _ in
            self?.viewModel.didSelectAdd(groupType: .project)
        }
        
        let actionStudy = UIAlertAction(title: "스터디", style: .default) { [weak self] _ in
            self?.viewModel.didSelectAdd(groupType: .study)
        }
        
        let actionCancel = UIAlertAction(title: "취소", style: .cancel)
        
        actionSheet.addAction(actionProject)
        actionSheet.addAction(actionStudy)
        actionSheet.addAction(actionCancel)
        
        present(actionSheet, animated: true)
    }
    
    @objc func didTapNotificationButton(_ sender: UIButton) {
        viewModel.didSelectNotifications()
    }
}

// MARK: - CLLocationManger Delegate
extension GroupListViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            manager.stopUpdatingLocation()
            let location = Location(
                latitude: location.coordinate.latitude,
                longitude: location.coordinate.longitude
            )
            viewModel.didUpdateUserLocation(location: location)
        }
    }
}

// MARK: - UICollectionView Delegate
extension GroupListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.viewModel.didSelectGroupCell(indexPath: indexPath)
    }
}

extension GroupListViewController {
    // 필터 닫혔을 때 아래 함수 실행
    func didSelectFilter(filter: Filter) {
        self.viewModel.updateFilter(filter: filter)
        self.viewModel.loadGroupList()
    }
}
