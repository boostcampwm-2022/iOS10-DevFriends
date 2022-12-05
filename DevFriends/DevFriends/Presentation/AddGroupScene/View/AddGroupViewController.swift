//
//  AddGroupViewController.swift
//  DevFriends
//
//  Created by 이대현 on 2022/11/23.
//

import Combine
import SnapKit
import UIKit

final class AddGroupViewController: UIViewController {
    private let addGroupScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private let titleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "제목"
        return textField
    }()
    
    private let chooseCategoryView = ChooseCategoryView()
    
    private let chooseLocationView = ChooseLocationView()
    
    private let limitPeopleLabel: UILabel = {
        let label = UILabel()
        label.text = "인원수"
        return label
    }()
    
    private let peopleNumberLabel: UILabel = {
        let label = UILabel()
        label.text = "2"
        return label
    }()
    
    private let limitPeopleStepper: UIStepper = {
        let stepper = UIStepper()
        stepper.value = 2
        stepper.minimumValue = 2
        stepper.maximumValue = 10
        return stepper
    }()
    
    private let descriptionTextView = CommonTextView(placeHolder: "게시글 내용을 작성해주세요.")
    
    private let submitButton = CommonButton(text: "작성 완료")
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    private let viewModel: AddGroupViewModel
    init(viewModel: AddGroupViewModel) {
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
    
    private func configureUI() {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.didConfigureView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        viewModel.didTouchedBackButton()
    }
    
    private func layout() {
        view.addSubview(submitButton)
        submitButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.height.equalTo(60)
        }
        
        view.addSubview(addGroupScrollView)
        addGroupScrollView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.right.equalTo(submitButton)
            make.bottom.equalTo(submitButton.snp.top).offset(-20)
        }
        
        addGroupScrollView.addSubview(titleTextField)
        titleTextField.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(50)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalTo(40)
        }
        
        let divider1 = DividerView()
        addGroupScrollView.addSubview(divider1)
        divider1.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(titleTextField)
            make.height.equalTo(1)
        }
        
        addGroupScrollView.addSubview(chooseCategoryView)
        chooseCategoryView.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp.bottom)
            make.left.right.equalTo(titleTextField)
        }
        
        let divider2 = DividerView()
        addGroupScrollView.addSubview(divider2)
        divider2.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(chooseCategoryView)
            make.height.equalTo(1)
        }
        
        addGroupScrollView.addSubview(chooseLocationView)
        chooseLocationView.snp.makeConstraints { make in
            make.top.equalTo(chooseCategoryView.snp.bottom)
            make.left.right.equalTo(chooseCategoryView)
        }
        
        let divider3 = DividerView()
        addGroupScrollView.addSubview(divider3)
        divider3.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(chooseLocationView)
            make.height.equalTo(1)
        }
        
        addGroupScrollView.addSubview(limitPeopleLabel)
        limitPeopleLabel.snp.makeConstraints { make in
            make.top.equalTo(chooseLocationView.snp.bottom).offset(20)
            make.left.equalTo(chooseLocationView)
        }
        
        addGroupScrollView.addSubview(limitPeopleStepper)
        limitPeopleStepper.snp.makeConstraints { make in
            make.centerY.equalTo(limitPeopleLabel)
            make.right.equalTo(chooseLocationView)
        }
        
        addGroupScrollView.addSubview(peopleNumberLabel)
        peopleNumberLabel.snp.makeConstraints { make in
            make.centerY.equalTo(limitPeopleStepper)
            make.right.equalTo(limitPeopleStepper.snp.left).offset(-20)
        }
        
        addGroupScrollView.addSubview(descriptionTextView)
        descriptionTextView.snp.makeConstraints { make in
            make.top.equalTo(limitPeopleLabel.snp.bottom).offset(20)
            make.left.equalTo(limitPeopleLabel)
            make.right.equalTo(limitPeopleStepper)
            make.height.equalTo(250)
            make.bottom.equalToSuperview().offset(-20)
        }
    }
    
    private func bind() {
        hideKeyboardWhenTappedAround()
            .store(in: &cancellables)

//        upViewByKeyboardHeight()
//            .store(in: &cancellables)
//
//        downViewByKeyboardHeight()
//            .store(in: &cancellables)
        
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
            .compactMap { $0 }
            .sink { [weak self] text in
                self?.viewModel.didDescriptionChanged(text: text)
            }
            .store(in: &cancellables)
        
        viewModel.didUpdateGroupTypeSubject
            .receive(on: RunLoop.main)
            .sink { [weak self] groupType in
                self?.titleTextField.placeholder = "\(groupType.rawValue) 제목"
                self?.navigationItem.title = "\(groupType.rawValue) 모집 글쓰기"
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
        
        if let backButton = self.navigationItem.backBarButtonItem {
            backButton.publisher
                .sink { [weak self] _ in
                    self?.viewModel.didTouchedBackButton()
                }
                .store(in: &cancellables)
        }
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
