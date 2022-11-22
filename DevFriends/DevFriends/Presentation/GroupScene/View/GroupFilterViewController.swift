//
//  GroupFilterViewController.swift
//  DevFriends
//
//  Created by 상현 on 2022/11/15.
//

import Combine
import SnapKit
import UIKit

final class GroupFilterViewController: DefaultViewController {
    enum SectionType: Int, CaseIterable {
        case align = 0
        case group = 1
        case category = 2
    }
        private let viewModel = DefaultGroupFilterViewModel(fetchCategoryUseCase: DefaultFetchCategoryUseCase(categoryRepository: DefaultCategoryRepository()))
    
    var categoryDataSource: [String] = []
    
    weak var delegate: GroupFilterViewControllerDelegate?
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.headerReferenceSize = CGSize(width: self.view.bounds.width, height: 50.0)
        layout.sectionInset = .init(top: 0, left: 0, bottom: 40, right: 0)
        
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
        collectionView.register(GroupFilterCollectionViewCell.self, forCellWithReuseIdentifier: GroupFilterCollectionViewCell.reuseIdentifier)
        
        collectionView.allowsMultipleSelection = true
        
        return collectionView
    }()
    
    // MARK: - Initializer
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
//        delegate?.selectFilter(self,
//                               didSelectAlignType: viewModel.selectedAlignType,
//                               didSelectGroupType: viewModel.selectedGroupType,
//                               didSelectCategoryType: viewModel.selectedCategoryTypes)
    }
    // MARK: - Setting
    
    override func configureUI() {
        self.view.backgroundColor = .white
        self.viewModel.loadCategories()
    }
    
    override func layout() {
        self.view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(70)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    
    override func bind() {
        viewModel.categoriesSubject
            .receive(on: RunLoop.main)
            .sink { updatedList in
                self.categoryDataSource = updatedList.map { $0.name }
            }.store(in: &cancellables)
        
//        viewModel.$categoryType
//            .receive(on: DispatchQueue.main)
//            .sink { [weak self] _ in
//                self?.collectionView.reloadSections(IndexSet(integer: 2))
//            }
//            .store(in: cancellabes)
    }
}

// MARK: - UICollectionView DataSource

extension GroupFilterViewController: UICollectionViewDataSource {
    // 섹션 개수
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return SectionType.allCases.count
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
            header.configure("카테고리")
        }
        
        return header
    }
    
    // 셀 개수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 || section == 1 {
            return 2
        } else {
            return categoryDataSource.count
        }
    }
    
    // 셀 정보
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: GroupFilterCollectionViewCell.reuseIdentifier,
            for: indexPath
        ) as? GroupFilterCollectionViewCell else { return UICollectionViewCell() }
        
        // 이 부분은 viewModel 구현 후에
        indexPath.item % 2 == 0 ? cell.configure("태그태그") : cell.configure("태그")
        if indexPath.item == 1 && indexPath.section == 0 {
            cell.isSelected = true
            collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .top)
        }
        // 지워주시면 됩니다
        
        cell.configure("테스트")
//        switch indexPath.section {
//        case 0: // 정렬 순서
//            cell.configure(viewModel.alignType[indexPath.item])
//
//            if viewModel.selectedAlignType == viewModel.alignType[indexPath.item] {
//                cell.isSelected = true
//                collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .top)
//            }
//        case 1: // 모임 종류
//            cell.configure(viewModel.groupType[indexPath.item])
//
//            if viewModel.selectedGroupType == viewModel.groupType[indexPath.item] {
//                cell.isSelected = true
//                collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .top)
//            }
//        case 2: // 태그 종류
//            cell.configure(viewModel.categoryType[indexPath.item])
//
//            if viewModel.selectedTagTypes.contains(viewModel.alignType[indexPath.item]) {
//                cell.isSelected = true
//                collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .top)
//            }
//        default:
//            break
//        }
        
        return cell
    }
}

// MARK: - UICollectionView Delegate

extension GroupFilterViewController: UICollectionViewDelegate {
    // 셀이 선택되기 전
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 2 { return true }
        
        collectionView.indexPathsForSelectedItems?
            .filter { $0.section == indexPath.section && $0 != indexPath }
            .forEach { collectionView.deselectItem(at: $0, animated: false) }
        return true
    }
    
    // 셀이 선택 해제되기 전
    func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
        if indexPath.section != 0 { return true }
        
        guard let indexPathsForSelectedItems = collectionView.indexPathsForSelectedItems else { return false }
        return !indexPathsForSelectedItems.filter { $0.section == indexPath.section }.contains(indexPath)
    }
    
    // 셀 선택
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        switch indexPath.section {
//        case 0: // 정렬 순서
//            viewModel.selectedAlignType = viewModel.alignType[indexPath.item]
//        case 1: // 모임 종류
//            viewModel.selectedGroupType = viewModel.groupType[indexPath.item]
//        case 2: // 태그 종류
//            viewModel.selectedTagTypes.append(viewModel.categoryType[indexPath.item])
//        default:
//            break
//        }
    }
    
    // 셀 선택 해제
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
//        switch indexPath.section {
//        case 0: // 정렬 순서
//            break
//        case 1: // 모임 종류
//            viewModel.selectedGroupType = nil
//        case 2: // 태그 종류
//            viewModel.selectedTagTypes.removeAll(where: $0 == viewModel.categoryType[indexPath.item])
//        default:
//            break
//        }
    }
}

// MARK: - UICollectionView DelegateFlowLayout

extension GroupFilterViewController: UICollectionViewDelegateFlowLayout {
    // 셀 동적 레이아웃
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        // 이 부분은 viewModel 구현 후에
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GroupFilterCollectionViewCell.reuseIdentifier, for: indexPath) as? GroupFilterCollectionViewCell else {
            return .zero
        }

        indexPath.item % 2 == 0 ? cell.configure("태그태그") : cell.configure("태그")
            
        let cellWidth = cell.width + 20

        return CGSize(width: cellWidth, height: 30)
        // 지워주시면 됩니다
        
//        let tagString: String!
//        switch indexPath.section {
//        case 0:
//            tagString = viewModel.alignType[indexPath.item]
//        case 1:
//            tagString = viewModel.groupType[indexPath.item]
//        case 2:
//            tagString = viewModel.categoryType[indexPath.item]
//        default:
//            tagString = ""
//        }
//        let cellSize = CGSize(width: tagString.size(withAttributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15)]).width + 20, height: 30)
//        return cellSize
    }
}
