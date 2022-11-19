//
//  GroupListViewController.swift
//  DevFriends
//
//  Created by 상현 on 2022/11/14.
//

import Combine
import SnapKit
import UIKit

final class GroupListViewController: DefaultViewController {
    private let viewModel = GroupListViewModel()
    private var recommandGroupsList: [GroupCellInfo] = []
    private var filteredGroupsList: [GroupCellInfo] = []
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "모임"
        label.font = .systemFont(ofSize: 25, weight: .bold)
        return label
    }()
    
    private lazy var groupAddButton: UIBarButtonItem = {
        let item = UIBarButtonItem()
        item.image = UIImage(systemName: "plus")
        item.tintColor = .black
        item.target = self
        item.action = #selector(didTapGroupAddButton)
        return item
    }()
    
    private lazy var notificationButton: UIBarButtonItem = {
        let item = UIBarButtonItem()
        item.image = UIImage(systemName: "bell")
        item.tintColor = .black
        item.target = self
        item.action = #selector(didTapNotificationButton)
        return item
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.compositionalLayout)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(
            GroupCollectionHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: GroupCollectionHeaderView.reuseIdentifier
        )
        collectionView.register(GroupCollectionViewCell.self, forCellWithReuseIdentifier: GroupCollectionViewCell.reuseIdentifier)
        
        return collectionView
    }()
    
    private lazy var compositionalLayout: UICollectionViewCompositionalLayout = {
        let layout = UICollectionViewCompositionalLayout { sectionNumber, _ -> NSCollectionLayoutSection? in
            
            let screenSize = UIScreen.main.bounds.size
            let padding = screenSize.width * 0.05
            
            if sectionNumber == 0 {
                let item = NSCollectionLayoutItem(
                    layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
                )
                item.contentInsets.trailing = padding
                
                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: .init(widthDimension: .fractionalWidth(0.90), heightDimension: .absolute(140)),
                    subitems: [item]
                )
                
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
                section.contentInsets.leading = padding
                section.contentInsets.top = 10
                section.contentInsets.bottom = 10
                
                // Header, Footer 레이아웃
                section.boundarySupplementaryItems = [
                    .init(
                        layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(150)),
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
                    layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(140)),
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
    
    // MARK: - Setting
    
    override func configureUI() {
        self.view.backgroundColor = .systemGray6
        self.viewModel.fetchRecommandGroups()
        self.viewModel.fetchFilteredGroups()
    }
    
    override func layout() {
        setupNavigation()
        
        self.view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    
    private func setupNavigation() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleLabel)
        self.navigationItem.rightBarButtonItems = [notificationButton, groupAddButton]
    }
    
    override func bind() {
        viewModel.$recommandGroups
            .sink { (updatedList: [GroupCellInfo]) in
                print("Updating RecommandGroups - ViewController")
                self.recommandGroupsList = updatedList
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }.store(in: &cancellables)
        
        viewModel.$filteredGroups
            .sink { (updatedList: [GroupCellInfo]) in
                print("Updating FilteredGroups - ViewController")
                self.filteredGroupsList = updatedList
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }.store(in: &cancellables)
        
        
//        viewModel.$filterTrigger
//            .receive(on: DispatchQueue.main)
//            .sink { [weak self] _ in
//                self?.collectionView.reloadData()
//            }
//            .store(in: cancellabes)
    }
}

// MARK: - Actions

extension GroupListViewController {
    @objc func didTapFilterButton(_ sender: UIButton) {
        let filterVC = GroupFilterViewController()
        present(filterVC, animated: true)
    }
    
    @objc func didTapGroupAddButton(_ sender: UIButton) {
        let actionSheet = UIAlertController(
            title: "모임 종류 선택",
            message: "어떤 모임을 추가하시겠습니까?",
            preferredStyle: .actionSheet
        )
        
        let actionProject = UIAlertAction(title: "프로젝트", style: .default) { _ in
            print("프로젝트 모임 생성")
        }
        
        let actionStudy = UIAlertAction(title: "스터디", style: .default) { _ in
            print("스터디 모임 생성")
        }
        
        let actionCancel = UIAlertAction(title: "취소", style: .cancel)
        
        actionSheet.addAction(actionProject)
        actionSheet.addAction(actionStudy)
        actionSheet.addAction(actionCancel)
        
        present(actionSheet, animated: true)
    }
    
    @objc func didTapNotificationButton(_ sender: UIButton) {
        print("알림 버튼 클릭")
    }
}

// MARK: - UICollectionView DataSource

extension GroupListViewController: UICollectionViewDataSource {
    // 섹션 개수
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }
    
    // 헤더 정보
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard
            kind == UICollectionView.elementKindSectionHeader,
            let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: GroupCollectionHeaderView.reuseIdentifier,
                for: indexPath
            ) as? GroupCollectionHeaderView else { return UICollectionReusableView() }
        
        if indexPath.section == 0 {
            header.set(title: "추천 모임")
        } else if indexPath.section == 1 {
            header.set(title: "모집중인 모임", self, #selector(didTapFilterButton))
        }
        
        return header
    }
    
    // 셀 개수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return recommandGroupsList.count
        } else {
            return filteredGroupsList.count
        }
    }
    
    // 셀 정보
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: GroupCollectionViewCell.reuseIdentifier,
            for: indexPath) as? GroupCollectionViewCell else { return UICollectionViewCell() }
        
        if indexPath.section == 0 {
            cell.setGroupInfoUI(recommandGroupsList[indexPath.item])
        } else {
            cell.setGroupInfoUI(filteredGroupsList[indexPath.item])
        }
        
        return cell
    }
}

// MARK: - UICollectionView Delegate

extension GroupListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Section \(indexPath.section) : \(indexPath.item)번째 아이템을 선택했습니다.")
    }
}
