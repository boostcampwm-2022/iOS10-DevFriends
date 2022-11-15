//
//  GroupFilterViewController.swift
//  DevFriends
//
//  Created by 상현 on 2022/11/15.
//

import Combine
import SnapKit
import UIKit

final class GroupFilterViewController: UIViewController {
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.headerReferenceSize = CGSize(width: self.view.bounds.width, height: 50.0)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(
            GroupFilterCollectionHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: GroupFilterCollectionHeaderView.id
        )
        collectionView.register(GroupFilterCollectionViewCell.self, forCellWithReuseIdentifier: GroupFilterCollectionViewCell.id)
        
        collectionView.allowsMultipleSelection = true
        
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
        
        self.view.backgroundColor = .systemGray6
        //        bindViewModel()
    }
    // MARK: - Configure UI
    
    private func buildHierarchy() {
        self.view.addSubview(collectionView)
    }

    private func setUpConstraints() {
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
}

// MARK: - Bind ViewModel

extension GroupFilterViewController {
    
    private func bindViewModel() { }
}

// MARK: - UICollectionView DataSource

extension GroupFilterViewController: UICollectionViewDataSource {
    
    // 섹션 개수
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        3
    }
    
    // 헤더 정보
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: GroupFilterCollectionHeaderView.id,
            for: indexPath
        ) as? GroupFilterCollectionHeaderView else { return UICollectionReusableView() }
        
        if indexPath.section == 0 {
            header.configure("정렬 순서")
        } else if indexPath.section == 1 {
            header.configure("모임 종류")
        } else {
            header.configure("태그")
        }
        
        return header
    }
    
    // 셀 개수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 || section == 1 {
            return 2
        } else {
            return 7
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: GroupFilterCollectionViewCell.id,
            for: indexPath
        ) as? GroupFilterCollectionViewCell else { return UICollectionViewCell() }
        
        cell.configure("태그태그")
        
        return cell
    }
}

// MARK: - UICollectionView Delegate

extension GroupFilterViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 2 { return }

        collectionView.indexPathsForSelectedItems?
            .filter { $0.section == indexPath.section && $0 != indexPath }
            .forEach { self.collectionView.deselectItem(at: $0, animated: false) }
    }
}
