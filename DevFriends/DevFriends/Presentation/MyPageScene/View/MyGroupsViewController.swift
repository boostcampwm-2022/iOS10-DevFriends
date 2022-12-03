//
//  MyGroupsViewController.swift
//  DevFriends
//
//  Created by 심주미 on 2022/11/23.
//

import UIKit

final class MyGroupsViewController: DefaultViewController {
    private lazy var groupCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: UIScreen.main.bounds.size.width, height: 140.0)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(
            GroupCollectionViewCell.self,
            forCellWithReuseIdentifier: GroupCollectionViewCell.reuseIdentifier
        )
        collectionView.delegate = self
        return collectionView
    }()
    
    private lazy var groupCollectionViewDiffableDataSource = UICollectionViewDiffableDataSource<Section, Group>(
        collectionView: groupCollectionView) { collectionView, indexPath, data in
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: GroupCollectionViewCell.reuseIdentifier,
            for: indexPath) as? GroupCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.set(data)
        return cell
    }
    
    private var groupCollectionViewSnapShot = NSDiffableDataSourceSnapshot<Section, Group>()
    
    let viewModel: MyGroupsViewModel
    
    init(viewModel: MyGroupsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureUI() {
        setupCollectionView()
    }
    
    func setupCollectionView() {
        groupCollectionViewSnapShot.appendSections([.main])
    }
    
    func populateSnapshot(data: [Group]) {
        groupCollectionViewSnapShot.appendItems(data)
        groupCollectionViewDiffableDataSource.apply(groupCollectionViewSnapShot)
    }
    
    override func layout() {
        view.addSubview(groupCollectionView)
        groupCollectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension MyGroupsViewController: UICollectionViewDelegate {
    
}
