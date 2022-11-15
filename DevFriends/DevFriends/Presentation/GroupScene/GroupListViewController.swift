//
//  GroupListViewController.swift
//  DevFriends
//
//  Created by 상현 on 2022/11/14.
//

import Combine
import SnapKit
import UIKit

final class GroupListViewController: UIViewController {
    
//    private let viewModel: GroupListViewModel!
    private var cancellabes = Set<AnyCancellable>()
    
    private lazy var groupAddButton: UIBarButtonItem = {
        let item = UIBarButtonItem()
        item.image = UIImage(systemName: "plus")
        return item
    }()
    
    private lazy var notificationButton: UIBarButtonItem = {
        let item = UIBarButtonItem()
        item.image = UIImage(systemName: "bell")
        return item
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 15, left: 0, bottom: 15, right: 0)
        layout.scrollDirection = .vertical
        layout.headerReferenceSize = .init(width: 130, height: 40)
        layout.itemSize = CGSize(width: UIScreen.main.bounds.size.width - 40, height: 140.0)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.register(
            GroupCollectionHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: GroupCollectionHeaderView.id
        )
        collectionView.register(GroupCollectionViewCell.self, forCellWithReuseIdentifier: GroupCollectionViewCell.id)
        
        return collectionView
    }()
    
    // MARK: - Initializer
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        buildHierarchy()
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        bindViewModel()
        self.view.backgroundColor = .systemGray6
    }
    // MARK: - Configure UI
    
    private func buildHierarchy() {
        setupNavigation()
        self.view.addSubview(collectionView)
    }
    
    private func setupNavigation() {
        self.title = "모임"
        self.navigationItem.rightBarButtonItems = [notificationButton, groupAddButton]
    }
    
    private func setUpConstraints() {
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(80)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
}

// MARK: - Actions

extension GroupListViewController {
    
    @objc func didTapFilterButton(_ sender: UIButton) {
        print("tap filter button")
    }
}

// MARK: - Bind ViewModel

extension GroupListViewController {
    
    private func bindViewModel() { }
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
                withReuseIdentifier: GroupCollectionHeaderView.id,
                for: indexPath
            ) as? GroupCollectionHeaderView else { return UICollectionReusableView() }
        
        if indexPath.section == 0 {
            header.configure(title: "추천 모임")
        } else if indexPath.section == 1 {
            header.configure(title: "모집중인 모임", self, #selector(didTapFilterButton))
        }
        
        return header
    }
    
    // 셀 개수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: GroupCollectionViewCell.id,
            for: indexPath
        ) as? GroupCollectionViewCell else { return UICollectionViewCell() }
        
        return cell
    }
}
