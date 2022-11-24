//
//  AddGroupViewController.swift
//  DevFriends
//
//  Created by 이대현 on 2022/11/23.
//

import Combine
import SnapKit
import UIKit

final class AddGroupViewController: DefaultViewController {
    private let groupType: GroupType
    
    private lazy var titleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "제목"
        return textField
    }()
    
    private lazy var categoryButton: UIButton = {
        let button = UIButton()
        button.setTitle("카테고리 선택", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        return button
    }()
    
    private lazy var locationButton: UIButton = {
        let button = UIButton()
        button.setTitle("위치 선택", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        return button
    }()
    
    private lazy var limitPeopleLabel: UILabel = {
        let label = UILabel()
        label.text = "인원수"
        return label
    }()
    
    private lazy var limitPeopleStepper: UIStepper = {
        let stepper = UIStepper()
        return stepper
    }()
    
    private lazy var descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.text = "텍스트뷰 플레이스홀더 어떻게 하지"
        return textView
    }()
    
    private lazy var submitButton: CommonButton = {
        let commonButton = CommonButton(text: "작성 완료")
        return commonButton
    }()
    
    init(groupType: GroupType) {
        self.groupType = groupType
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureUI() {
        titleTextField.placeholder = "\(groupType.rawValue) 제목"
    }
    
    override func layout() {
        view.addSubview(titleTextField)
        titleTextField.backgroundColor = .green
        titleTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(50)
            make.left.equalTo(view.safeAreaLayoutGuide).offset(30)
            make.right.equalTo(view.safeAreaLayoutGuide).offset(-30)
            make.height.equalTo(40)
        }
        
        view.addSubview(categoryButton)
        categoryButton.backgroundColor = .blue
        categoryButton.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp.bottom).offset(20)
            make.left.right.equalTo(titleTextField)
            make.height.equalTo(40)
        }
        
        view.addSubview(locationButton)
        locationButton.backgroundColor = .red
        locationButton.snp.makeConstraints { make in
            make.top.equalTo(categoryButton.snp.bottom).offset(20)
            make.left.right.equalTo(categoryButton)
            make.height.equalTo(40)
        }
        
        view.addSubview(limitPeopleLabel)
        limitPeopleLabel.snp.makeConstraints { make in
            make.top.equalTo(locationButton.snp.bottom).offset(20)
            make.left.equalTo(locationButton)
        }
        
        view.addSubview(limitPeopleStepper)
        limitPeopleStepper.snp.makeConstraints { make in
            make.top.equalTo(limitPeopleLabel)
            make.centerY.equalTo(limitPeopleLabel)
            make.right.equalTo(locationButton)
        }
        
        view.addSubview(submitButton)
        submitButton.snp.makeConstraints { make in
            make.left.right.equalTo(locationButton)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-60)
            make.height.equalTo(60)
        }
        
        view.addSubview(descriptionTextView)
        descriptionTextView.snp.makeConstraints { make in
            make.top.equalTo(limitPeopleLabel.snp.bottom).offset(20)
            make.left.equalTo(limitPeopleLabel)
            make.right.equalTo(limitPeopleStepper)
            make.bottom.equalTo(submitButton.snp.top).offset(-20)
        }
    }
    
    override func bind() {
        categoryButton.publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                self?.showChooseCategoryView()
            }
            .store(in: &cancellables)
        
        locationButton.publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                self?.showChooseLocationView()
            }
            .store(in: &cancellables)
    }
    
    private func showChooseCategoryView() {
        let chooseCategoryView = ChooseCategoryViewController()
        self.present(chooseCategoryView, animated: true)
    }
    
    private func showChooseLocationView() {
        let chooseLocationView = ChooseLocationViewController()
        self.present(chooseLocationView, animated: true)
    }
}
