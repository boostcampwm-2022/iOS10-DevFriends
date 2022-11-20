//
//  MogakcoModalViewController.swift
//  DevFriends
//
//  Created by 이대현 on 2022/11/16.
//

import UIKit
import SnapKit

final class MogakcoModalViewController: DefaultViewController {
    private lazy var mogakcoListCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: UIScreen.main.bounds.size.width, height: 140.0)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(GroupCollectionViewCell.self, forCellWithReuseIdentifier: GroupCollectionViewCell.reuseIdentifier)
        return collectionView
    }()
    
    private lazy var mogakcoCollectionViewDiffableDataSource = UICollectionViewDiffableDataSource<Section, Group>(collectionView: mogakcoListCollectionView) { collectionView, indexPath, data in
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GroupCollectionViewCell.reuseIdentifier,
                                                            for: indexPath) as? GroupCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.set(data)
        return cell
    }
    
    private var mogakcoCollectionViewSnapShot = NSDiffableDataSourceSnapshot<Section, Group>()
    
    override func configureUI() {
        view.backgroundColor = .white
    }
    
    override func layout() {
        view.addSubview(mogakcoListCollectionView)
        mogakcoListCollectionView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(50)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview().offset(-20)
        }
    }
    
    func populateSnapshot(data: [Group]) {
        mogakcoCollectionViewSnapShot.deleteAllItems()
        mogakcoCollectionViewSnapShot.appendSections([.main])
        mogakcoCollectionViewSnapShot.appendItems(data)
        mogakcoCollectionViewDiffableDataSource.apply(mogakcoCollectionViewSnapShot)
    }
}
