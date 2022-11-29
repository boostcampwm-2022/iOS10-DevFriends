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
    
    private lazy var chooseCategoryView = ChooseCategoryView()
    
    private lazy var chooseLocationView = ChooseLocationView()
    
    private lazy var limitPeopleLabel: UILabel = {
        let label = UILabel()
        label.text = "인원수"
        return label
    }()
    
    private lazy var peopleNumberLabel: UILabel = {
        let label = UILabel()
        label.text = "2"
        return label
    }()
    
    private lazy var limitPeopleStepper: UIStepper = {
        let stepper = UIStepper()
        stepper.value = 2
        stepper.minimumValue = 2
        stepper.maximumValue = 10
        return stepper
    }()
    
    private lazy var descriptionTextView = CommonTextView(placeHolder: "게시글 내용을 작성해주세요.")
    
    private lazy var submitButton = CommonButton(text: "작성 완료")
    
    init(groupType: GroupType) {
        self.groupType = groupType
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureUI() {
        titleTextField.placeholder = "\(groupType.rawValue) 제목"
        hideKeyboardWhenTapped()
        adjustViewToKeyboard()
    }
    
    override func layout() {
        view.addSubview(titleTextField)
        titleTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(50)
            make.left.equalTo(view.safeAreaLayoutGuide).offset(30)
            make.right.equalTo(view.safeAreaLayoutGuide).offset(-30)
            make.height.equalTo(40)
        }
        
        let divider1 = DividerView()
        view.addSubview(divider1)
        divider1.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(titleTextField)
            make.height.equalTo(1)
        }
        
        view.addSubview(chooseCategoryView)
        chooseCategoryView.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp.bottom)
            make.left.right.equalTo(titleTextField)
        }
        
        let divider2 = DividerView()
        view.addSubview(divider2)
        divider2.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(chooseCategoryView)
            make.height.equalTo(1)
        }
        
        view.addSubview(chooseLocationView)
        chooseLocationView.snp.makeConstraints { make in
            make.top.equalTo(chooseCategoryView.snp.bottom)
            make.left.right.equalTo(chooseCategoryView)
        }
        
        let divider3 = DividerView()
        view.addSubview(divider3)
        divider3.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(chooseLocationView)
            make.height.equalTo(1)
        }
        
        view.addSubview(limitPeopleLabel)
        limitPeopleLabel.snp.makeConstraints { make in
            make.top.equalTo(chooseLocationView.snp.bottom).offset(20)
            make.left.equalTo(chooseLocationView)
        }
        
        view.addSubview(limitPeopleStepper)
        limitPeopleStepper.snp.makeConstraints { make in
            make.centerY.equalTo(limitPeopleLabel)
            make.right.equalTo(chooseLocationView)
        }
        
        view.addSubview(peopleNumberLabel)
        peopleNumberLabel.snp.makeConstraints { make in
            make.centerY.equalTo(limitPeopleStepper)
            make.right.equalTo(limitPeopleStepper.snp.left).offset(-20)
        }
        
        view.addSubview(descriptionTextView)
        descriptionTextView.snp.makeConstraints { make in
            make.top.equalTo(limitPeopleLabel.snp.bottom).offset(20)
            make.left.equalTo(limitPeopleLabel)
            make.right.equalTo(limitPeopleStepper)
            make.height.equalTo(250)
        }
        
        view.addSubview(submitButton)
        submitButton.snp.makeConstraints { make in
            make.left.right.equalTo(chooseLocationView)
            make.top.equalTo(descriptionTextView.snp.bottom).offset(20)
            make.height.equalTo(60)
        }
    }
    
    override func bind() {
        chooseCategoryView.didTouchViewSubject
            .sink { [weak self] _ in
                self?.showChooseCategoryView()
            }
            .store(in: &cancellables)

        chooseLocationView.didTouchViewSubject
            .sink { [weak self] _ in
                self?.showChooseLocationView()
            }
            .store(in: &cancellables)
        
        limitPeopleStepper.publisher(for: .valueChanged)
            .sink { [weak self] _ in
                self?.setStepperValue()
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
    
    private func setStepperValue() {
        peopleNumberLabel.text = Int(limitPeopleStepper.value).description
    }
}