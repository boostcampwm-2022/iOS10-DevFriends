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
    
    private lazy var separator: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray5
        return view
    }()
    
    private lazy var chooseCategoryView: ChooseCategoryView = {
        let view = ChooseCategoryView()
        return view
    }()
    
    private lazy var separator2: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray5
        return view
    }()
    
    private lazy var chooseLocationView: ChooseLocationView = {
        let view = ChooseLocationView()
        return view
    }()
    
    private lazy var separator3: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray5
        return view
    }()
    
    private lazy var limitPeopleLabel: UILabel = {
        let label = UILabel()
        label.text = "인원수"
        return label
    }()
    
    private lazy var peopleNumberLabel: UILabel = {
        let label = UILabel()
        label.text = "1"
        return label
    }()
    
    private lazy var limitPeopleStepper: UIStepper = {
        let stepper = UIStepper()
        stepper.value = 1
        stepper.minimumValue = 1
        stepper.maximumValue = 10
        return stepper
    }()
    
    private lazy var descriptionTextView: UITextView = {
        let textView = CommonTextView(placeHolder: "게시글 내용을 작성해주세요.")
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
        hideKeyboardWhenTapped()
        adjustViewToKeyboard()
        // TODO: Navigation bar 위로 불투명하게 만들고 싶다...
        // 키보드땜에 뷰가 위로 올라갈 때 문제가 있음
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = .green
    }
    
    override func layout() {
        view.addSubview(titleTextField)
        titleTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(50)
            make.left.equalTo(view.safeAreaLayoutGuide).offset(30)
            make.right.equalTo(view.safeAreaLayoutGuide).offset(-30)
            make.height.equalTo(40)
        }
        
        view.addSubview(separator)
        separator.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(titleTextField)
            make.height.equalTo(1)
        }
        
        view.addSubview(chooseCategoryView)
        chooseCategoryView.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp.bottom)
            make.left.right.equalTo(titleTextField)
        }
        
        view.addSubview(separator2)
        separator2.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(chooseCategoryView)
            make.height.equalTo(1)
        }
        
        view.addSubview(chooseLocationView)
        chooseLocationView.snp.makeConstraints { make in
            make.top.equalTo(chooseCategoryView.snp.bottom)
            make.left.right.equalTo(chooseCategoryView)
        }
        
        view.addSubview(separator3)
        separator3.snp.makeConstraints { make in
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
        
        view.addSubview(submitButton)
        submitButton.snp.makeConstraints { make in
            make.left.right.equalTo(chooseLocationView)
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
