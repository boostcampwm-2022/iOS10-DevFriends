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
    enum SectionType: Int, CaseIterable {
        case align = 0
        case group = 1
        case category = 2
    }

    var initialFilter: Filter?
    
    private lazy var collectionView: UICollectionView = {
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
            withReuseIdentifier: GroupFilterCollectionHeaderView.reuseIdentifier
        )
        collectionView.register(cellType: GroupFilterCollectionViewCell.self)
        
        collectionView.allowsMultipleSelection = true
        
        return collectionView
    }()
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initializer
    
    private let viewModel: GroupFilterViewModel
    
    init(viewModel: GroupFilterViewModel) {
        self.viewModel = viewModel
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
        if let initialFilter = initialFilter {
            self.viewModel.initFilter(filter: initialFilter)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let filter = Filter(
            alignFilter: self.viewModel.alignFilter,
            groupFilter: self.viewModel.groupFilter,
            categoryFilter: self.viewModel.categoryFilter
        )
        viewModel.sendFilter(filter: filter)
    }
    // MARK: - Setting
    
    private func configureUI() {
        self.view.backgroundColor = .devFriendsReverseBase
        self.viewModel.loadCategories()
    }
    
    private func layout() {
        self.view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(70)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    
    private func bind() {
        viewModel.didUpdateFilterSubject
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.collectionView.reloadData()
            }
            .store(in: &cancellables)
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
            withReuseIdentifier: GroupFilterCollectionHeaderView.reuseIdentifier,
            for: indexPath
        ) as? GroupFilterCollectionHeaderView else { return UICollectionReusableView() }
        
        if indexPath.section == SectionType.align.rawValue {
            header.configure("정렬 순서")
        } else if indexPath.section == SectionType.group.rawValue {
            header.configure("모임 종류")
        } else {
            header.configure("카테고리")
        }
        
        return header
    }
    
    // 셀 개수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == SectionType.align.rawValue {
            return viewModel.alignType.count
        } else if section == SectionType.group.rawValue {
            return viewModel.groupType.count
        } else {
            return viewModel.categoryType.count
        }
    }
    
    // 셀 정보
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: GroupFilterCollectionViewCell.reuseIdentifier,
            for: indexPath
        ) as? GroupFilterCollectionViewCell else { return UICollectionViewCell() }
  
        switch indexPath.section {
        case SectionType.align.rawValue: // 정렬 순서
            cell.configure(viewModel.alignType[indexPath.item].rawValue)
            if viewModel.alignType[indexPath.item] == viewModel.alignFilter {
                collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .top)
            }
        case SectionType.group.rawValue: // 모임 종류
            cell.configure(viewModel.groupType[indexPath.item].rawValue)
            if let groupFilter = viewModel.groupFilter,
               groupFilter == viewModel.groupType[indexPath.item] {
                collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .top)
            }
        case SectionType.category.rawValue: // 태그 종류
            cell.configure(viewModel.categoryType[indexPath.item].name)
            if viewModel.categoryFilter.contains(viewModel.categoryType[indexPath.item].id) {
                collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .top)
            }
        default:
            break
        }
        
        return cell
    }
}

// MARK: - UICollectionView Delegate

extension GroupFilterViewController: UICollectionViewDelegate {
    // 셀이 선택되기 전
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        if indexPath.section == SectionType.category.rawValue { return true }
        
        collectionView.indexPathsForSelectedItems?
            .filter { $0.section == indexPath.section && $0 != indexPath }
            .forEach { collectionView.deselectItem(at: $0, animated: false) }
        return true
    }
    
    // 셀이 선택 해제되기 전
    func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
        if indexPath.section != SectionType.align.rawValue { return true }
        
        guard let indexPathsForSelectedItems = collectionView.indexPathsForSelectedItems else { return false }
        return !indexPathsForSelectedItems.filter { $0.section == indexPath.section }.contains(indexPath)
    }
    
    // 셀 선택
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case SectionType.align.rawValue: // 정렬 순서
            viewModel.setAlignFilter(type: viewModel.alignType[indexPath.item])
        case SectionType.group.rawValue: // 모임 종류
            viewModel.setGroupFilter(type: viewModel.groupType[indexPath.item])
        case SectionType.category.rawValue: // 태그 종류
            viewModel.setCategoryFilter(category: viewModel.categoryType[indexPath.item])
        default:
            break
        }
        guard let cell = collectionView.cellForItem(at: indexPath) as? GroupFilterCollectionViewCell else { return }
        cell.isSelected = true
    }
    
    // 셀 선택 해제
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case SectionType.align.rawValue: // 정렬 순서
            break
        case SectionType.group.rawValue: // 모임 종류
            viewModel.removeAllGroupFilter()
        case SectionType.category.rawValue: // 태그 종류
            viewModel.removeCategoryFilter(category: viewModel.categoryType[indexPath.item])
        default:
            break
        }
        guard let cell = collectionView.cellForItem(at: indexPath) as? GroupFilterCollectionViewCell else { return }
        cell.isSelected = false
    }
}

// MARK: - UICollectionView DelegateFlowLayout

extension GroupFilterViewController: UICollectionViewDelegateFlowLayout {
    // 셀 동적 레이아웃
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let tagString: String
        switch indexPath.section {
        case SectionType.align.rawValue:
            tagString = viewModel.alignType[indexPath.item].rawValue
        case SectionType.group.rawValue:
            tagString = viewModel.groupType[indexPath.item].rawValue
        case SectionType.category.rawValue:
            tagString = viewModel.categoryType[indexPath.item].name
        default:
            tagString = ""
        }
        let cellSize = CGSize(width: tagString.size(withAttributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15)]).width + 20, height: 30)
        return cellSize
    }
}
