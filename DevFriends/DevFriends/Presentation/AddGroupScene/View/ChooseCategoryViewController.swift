//
//  ChooseCategoryViewController.swift
//  DevFriends
//
//  Created by 이대현 on 2022/11/24.
//

import Combine
import SnapKit
import UIKit


final class ChooseCategoryViewController: DefaultViewController {
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.text = "카테고리 선택"
        return label
    }()
    
    private lazy var categoryTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.allowsMultipleSelection = true
        tableView.delegate = self
        return tableView
    }()
    
    private lazy var categoryTableViewDiffableDataSource: UITableViewDiffableDataSource<Section, Category> = {
        let diffableDataSource = UITableViewDiffableDataSource<Section, Category>(
            tableView: categoryTableView
        ) { _, _, data -> UITableViewCell in
            let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
            cell.textLabel?.text = data.name
            return cell
        }
        return diffableDataSource
    }()
    
    private lazy var categoryTableViewSnapShot = NSDiffableDataSourceSnapshot<Section, Category>()
    
    private lazy var submitButton: CommonButton = {
        let button = CommonButton(text: "작성 완료")
        return button
    }()
    
    override func configureUI() {
        view.backgroundColor = .white
        viewModel.loadCategories()
    }
    
    // MARK: - Initializer
    private let viewModel: ChooseCategoryViewModel
    
    init(viewModel: ChooseCategoryViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layout() {
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.left.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
        
        view.addSubview(categoryTableView)
        categoryTableView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.left.equalTo(titleLabel)
            make.right.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-100)
        }
        
        view.addSubview(submitButton)
        submitButton.snp.makeConstraints { make in
            make.top.equalTo(categoryTableView.snp.bottom).offset(20)
            make.left.right.equalTo(categoryTableView)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
        }
    }
    
    private func loadTableView() {
        categoryTableViewSnapShot.appendSections([.main])
        populateSnapshot(data: self.viewModel.categoryType)
    }
    
    private func populateSnapshot(data: [Category]) {
        categoryTableViewSnapShot.appendItems(data)
        categoryTableViewDiffableDataSource.apply(categoryTableViewSnapShot)
    }
    
    override func bind() {
        submitButton.publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                self?.viewModel.sendCategorySelection()
            }
            .store(in: &cancellables)
        
        viewModel.didUpdateSelectionSubject
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.loadTableView()
            }
            .store(in: &cancellables)
    }
}

extension ChooseCategoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selected: Category = self.categoryTableViewSnapShot.itemIdentifiers[indexPath.row]
        viewModel.addCategory(category: selected)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let selected: Category = self.categoryTableViewSnapShot.itemIdentifiers[indexPath.row]
        viewModel.removeCategory(category: selected)
    }
}
