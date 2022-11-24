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
    private lazy var categoryTableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    private lazy var categoryTableViewDiffableDataSource: UITableViewDiffableDataSource<Section, String> = {
        let diffableDataSource = UITableViewDiffableDataSource<Section, String>(
            tableView: categoryTableView
        ) { tableView, indexPath, data -> UITableViewCell in
            let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
            cell.textLabel?.text = data
            return cell
        }
        return diffableDataSource
    }()
    
    private lazy var categoryTableViewSnapShot = NSDiffableDataSourceSnapshot<Section, String>()
    
    private lazy var submitButton: CommonButton = {
        let button = CommonButton(text: "작성 완료")
        return button
    }()
    
    override func configureUI() {
        view.backgroundColor = .white
        self.setupTableView()
    }
    
    override func layout() {
        view.addSubview(categoryTableView)
        categoryTableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.left.equalTo(view.safeAreaLayoutGuide).offset(20)
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
    
    private func setupTableView() {
        categoryTableViewSnapShot.appendSections([.main])
        let data = [Category(id: "", name: "C언어"),
                    Category(id: "", name: "Swift"),
                    Category(id: "", name: "Java")]
        populateSnapshot(data: data)
    }
    
    private func populateSnapshot(data: [Category]) {
        var newItems = data.map { $0.name }
        newItems.append("전체")
        categoryTableViewSnapShot.appendItems(newItems)
        categoryTableViewDiffableDataSource.apply(categoryTableViewSnapShot)
    }
}
