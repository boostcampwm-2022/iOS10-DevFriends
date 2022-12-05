//
//  FixMyInfoViewController.swift
//  DevFriends
//
//  Created by 심주미 on 2022/11/22.
//

import Combine
import PhotosUI
import UIKit

final class FixMyInfoViewController: UIViewController {
    private lazy var backBarButton: UIBarButtonItem = {
        let barButton = UIBarButtonItem()
        barButton.image = .chevronLeft
        barButton.style = .plain
        barButton.tintColor = .black
        return barButton
    }()
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    private lazy var contentView: UIView = {
        let view = UIView()
        return view
    }()
    private lazy var profileImageViewHeight = view.frame.width - 100
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .profile
        imageView.layer.cornerRadius = profileImageViewHeight / 2
        imageView.layer.masksToBounds = true
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private lazy var nicknameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "닉네임을 입력해주세요 or 사용자 이름"
        textField.borderStyle = .roundedRect
        textField.delegate = self
        return textField
    }()
    
    private lazy var jobTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "직업을 입력해주세요"
        textField.borderStyle = .roundedRect
        textField.delegate = self
        return textField
    }()
    
    private let fixDoneButton = CommonButton(text: "수정 완료")
    
    private lazy var imagePicker: PHPickerViewController = {
        var config = PHPickerConfiguration()
        config.filter = .any(of: [.images])
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        return picker
    }()
    
    private var cancellables = Set<AnyCancellable>()
    
    private let viewModel: FixMyInfoViewModel
    
    init(viewModel: FixMyInfoViewModel) {
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
    
    private func layout() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        contentView.addSubview(profileImageView)
        profileImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(20)
            make.width.height.equalTo(profileImageViewHeight)
        }
        
        let nicknameLabel = makeTitleLabel(text: "닉네임")
        contentView.addSubview(nicknameLabel)
        nicknameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(25)
            make.top.equalTo(profileImageView.snp.bottom).offset(25)
        }
        
        contentView.addSubview(nicknameTextField)
        nicknameTextField.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(25)
            make.trailing.equalToSuperview().offset(-25)
            make.top.equalTo(nicknameLabel.snp.bottom).offset(15)
        }
        
        let jobLabel = makeTitleLabel(text: "직업")
        contentView.addSubview(jobLabel)
        jobLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(25)
            make.top.equalTo(nicknameTextField.snp.bottom).offset(25)
        }
        
        contentView.addSubview(jobTextField)
        jobTextField.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(25)
            make.trailing.equalToSuperview().offset(-25)
            make.top.equalTo(jobLabel.snp.bottom).offset(15)
        }
        
        contentView.addSubview(fixDoneButton)
        fixDoneButton.snp.makeConstraints { make in
            make.top.equalTo(jobTextField.snp.bottom).offset(80)
            make.bottom.equalToSuperview().offset(-100)
            make.leading.equalToSuperview().offset(25)
            make.trailing.equalToSuperview().offset(-25)
            make.height.equalTo(40)
        }
    }
    
    private func configureUI() {
        self.view.backgroundColor = .white
        
        nicknameTextField.text = viewModel.userNickName
        jobTextField.text = viewModel.userJob
        viewModel.didLoadUser()
        setupNavigation()
    }
    
    func setupNavigation() {
        navigationItem.leftBarButtonItems = [backBarButton]
        navigationItem.title = "회원정보 수정"
    }
    
    private func bind() {
        self.hideKeyboardWhenTappedAround()
            .store(in: &cancellables)
        
        self.backBarButton.publisher
            .sink { [weak self] _ in
                self?.didTouchedBackButton()
            }
            .store(in: &cancellables)
        
        self.profileImageView.gesturePublisher()
            .sink { [weak self] _ in
                if let nicknameEditing = self?.nicknameTextField.isEditing,
                   let jobEditing = self?.jobTextField.isEditing,
                   nicknameEditing || jobEditing == true {
                    self?.view.endEditing(true)
                    return
                }
                
                self?.makeImageAlertSheet()
            }
            .store(in: &cancellables)
        
        self.fixDoneButton.publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                guard let nickname = self?.nicknameTextField.text, let job = self?.jobTextField.text else { return }
                self?.viewModel.didTapDoneButton(nickname: nickname, job: job)
            }
            .store(in: &cancellables)
        
        self.viewModel.profileImageSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] image in
                if let image = image {
                    self?.profileImageView.image = image
                } else {
                    self?.profileImageView.image = .profile
                }
            }
            .store(in: &cancellables)
    }
    
    private func makeTitleLabel(text: String) -> UILabel {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.text = text
        return label
    }
    
    private func makeImageAlertSheet() {
        let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: "앨범에서 선택", style: .default) { [weak self] _ in
            guard let imagePicker = self?.imagePicker else { return }
            self?.present(imagePicker, animated: true)
        })
        sheet.addAction(UIAlertAction(title: "기본 이미지", style: .default) { [weak self] _ in
            DispatchQueue.main.async {
                self?.viewModel.profileImageSubject.value = nil
            }
        })
        sheet.addAction(UIAlertAction(title: "취소", style: .cancel))
        
        self.present(sheet, animated: true)
    }
    
    private func makeDisableImageAlert() {
        let alert = UIAlertController(
            title: "선택할 수 없는 이미지입니다",
            message: nil,
            preferredStyle: .alert
        )
        
        DispatchQueue.main.async { [weak self] in
            self?.present(alert, animated: true)
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            alert.dismiss(animated: true)
        }
    }
    
    private func didTouchedBackButton() {
        viewModel.didTouchedBackButton()
    }
}

// MARK: Image

extension FixMyInfoViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        guard let itemProvider = results.first?.itemProvider else { return }
        
        if itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, _ in
                guard let image = image as? UIImage else {
                    self?.makeDisableImageAlert()
                    return
                }
                
                DispatchQueue.main.async {
                    self?.viewModel.profileImageSubject.value = image
                }
            }
        }
    }
}

// MARK: Keyboard

extension FixMyInfoViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let currentYPosition: CGFloat
        
        switch textField {
        case nicknameTextField:
            currentYPosition = UIScreen.main.bounds.height - nicknameTextField.frame.origin.y
        case jobTextField:
            currentYPosition = UIScreen.main.bounds.height - jobTextField.frame.origin.y
        default:
            currentYPosition = 0
        }
        
        let keyboardHeight = 375.0
        if keyboardHeight > currentYPosition {
            self.view.frame.origin.y = -(keyboardHeight - currentYPosition)
        } else {
            self.view.frame.origin.y = 0
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        self.view.frame.origin.y = 0
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case nicknameTextField:
            jobTextField.becomeFirstResponder()
        case jobTextField:
            jobTextField.resignFirstResponder()
        default:
            return false
        }
        return true
    }
}
