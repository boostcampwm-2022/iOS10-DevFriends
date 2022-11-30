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
    
    // MARK: - Init
    private let viewModel: AddGroupViewModel
    init(viewModel: AddGroupViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureUI() {
        hideKeyboardWhenTapped()
        adjustViewToKeyboard()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.didConfigureView()
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
        titleTextField.publisher(for: .editingDidEnd)
            .sink { [weak self] _ in
                if let title = self?.titleTextField.text {
                    self?.viewModel.didTitleEdited(title: title)
                }
            }
            .store(in: &cancellables)
        
        chooseCategoryView.didTouchViewSubject
            .sink { [weak self] _ in
                self?.viewModel.didCategorySelect()
            }
            .store(in: &cancellables)

        chooseLocationView.didTouchViewSubject
            .sink { [weak self] _ in
                self?.viewModel.didLocationSelect()
            }
            .store(in: &cancellables)
        
        limitPeopleStepper.publisher(for: .valueChanged)
            .sink { [weak self] _ in
                self?.setStepperValue()
            }
            .store(in: &cancellables)
        
        descriptionTextView.textPublisher
            .sink { [weak self] text in
                if let text = text {
                    self?.viewModel.didDescriptionChanged(text: text)
                }
            }
            .store(in: &cancellables)
        
        viewModel.didUpdateGroupTypeSubject
            .receive(on: RunLoop.main)
            .sink { [weak self] groupType in
                self?.titleTextField.placeholder = "\(groupType.rawValue) 제목"
            }
            .store(in: &cancellables)
        
        viewModel.didUpdateCategorySubject
            .receive(on: RunLoop.main)
            .sink { [weak self] updatedCategories in
                self?.chooseCategoryView.set(categories: updatedCategories)
            }
            .store(in: &cancellables)
        
        viewModel.didUpdateLocationSubject
            .receive(on: RunLoop.main)
            .sink { [weak self] updatedLocation in
                self?.chooseLocationView.set(location: updatedLocation)
            }
            .store(in: &cancellables)
        
        submitButton.publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                self?.viewModel.didSendGroupInfo()
                self?.navigationController?.popViewController(animated: true)
            }
            .store(in: &cancellables)
    }
    
    private func setStepperValue() {
        peopleNumberLabel.text = Int(limitPeopleStepper.value).description
        self.viewModel.didLimitPeopleChanged(limit: Int(limitPeopleStepper.value))
    }
}

// CategoryView에서 가져온 Category 정보 업데이트
extension AddGroupViewController {
    func updateCategories(categories: [Category]) {
        self.viewModel.updateCategory(categories: categories)
    }
    
    func updateLocation(location: Location) {
        self.viewModel.updateLocation(location: location)
    }
}
