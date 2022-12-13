//
//  MogakcoModalViewController.swift
//  DevFriends
//
//  Created by 이대현 on 2022/11/16.
//

import UIKit
import SnapKit

struct MogakcoModalViewActions {
    let didSelectMogakcoCell: (Location) -> Void
}

final class MogakcoModalViewController: UIViewController {
    private lazy var mogakcoListCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: UIScreen.main.bounds.size.width, height: 140.0)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .devFriendsReverseBase
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(cellType: GroupCollectionViewCell.self)
        collectionView.delegate = self
        return collectionView
    }()
    
    private lazy var mogakcoCollectionViewDiffableDataSource = UICollectionViewDiffableDataSource<Section, Group>(collectionView: mogakcoListCollectionView) { collectionView, indexPath, data in
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: GroupCollectionViewCell.reuseIdentifier,
            for: indexPath
        ) as? GroupCollectionViewCell else { return UICollectionViewCell() }
        
        cell.set(data)
        return cell
    }
    
    private var mogakcoCollectionViewSnapShot = NSDiffableDataSourceSnapshot<Section, Group>()
    
    private let actions: MogakcoModalViewActions

    init(actions: MogakcoModalViewActions) {
        self.actions = actions
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
        self.layout()
    }
    
    private func configureUI() {
        view.backgroundColor = .devFriendsReverseBase
    }
    
    private func layout() {
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

extension MogakcoModalViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row < mogakcoCollectionViewSnapShot.itemIdentifiers.count {
            let group = mogakcoCollectionViewSnapShot.itemIdentifiers[indexPath.row]
            actions.didSelectMogakcoCell(group.location)
        }
    }
}
