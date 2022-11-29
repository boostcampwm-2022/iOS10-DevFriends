//
//  FixMyInfoViewController.swift
//  DevFriends
//
//  Created by 심주미 on 2022/11/22.
//

import PhotosUI
import UIKit

final class FixMyInfoViewController: DefaultViewController {
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
        return textField
    }()
    
    private lazy var jobTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "직업을 입력해주세요"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private lazy var fixDoneButton = CommonButton(text: "수정 완료")
    
    private lazy var imageConfiguration: PHPickerConfiguration = {
        var config = PHPickerConfiguration()
        config.filter = .any(of: [.images])
        return config
    }()
    
    private lazy var imagePicker: PHPickerViewController = {
        let picker = PHPickerViewController(configuration: self.imageConfiguration)
        picker.delegate = self
        return picker
    }()
    
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
        
        setupViews()
    }
    
    override func layout() {
        view.addSubview(profileImageView)
        profileImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.width.height.equalTo(profileImageViewHeight)
        }
        
        let nicknameLabel = makeTitleLabel(text: "닉네임")
        view.addSubview(nicknameLabel)
        nicknameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(25)
            make.top.equalTo(profileImageView.snp.bottom).offset(25)
        }
        
        view.addSubview(nicknameTextField)
        nicknameTextField.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(25)
            make.trailing.equalToSuperview().offset(-25)
            make.top.equalTo(nicknameLabel.snp.bottom).offset(15)
        }
        
        let jobLabel = makeTitleLabel(text: "직업")
        view.addSubview(jobLabel)
        jobLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(25)
            make.top.equalTo(nicknameTextField.snp.bottom).offset(25)
        }
        
        view.addSubview(jobTextField)
        jobTextField.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(25)
            make.trailing.equalToSuperview().offset(-25)
            make.top.equalTo(jobLabel.snp.bottom).offset(15)
        }
        
        view.addSubview(fixDoneButton)
        fixDoneButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalToSuperview().offset(25)
            make.trailing.equalToSuperview().offset(-25)
            make.height.equalTo(40)
        }
    }
    
    private func setupViews() {
        self.view.backgroundColor = .white
        
        nicknameTextField.text = viewModel.userNickName
        jobTextField.text = viewModel.userJob
        viewModel.didLoadUser()
    }
    
    override func bind() {
        self.hideKeyboardWhenTappedAround()
        
        self.profileImageView.gesturePublisher()
            .sink { [weak self] _ in
                if let nicknameEditing = self?.nicknameTextField.isEditing,
                   let jobEditing = self?.jobTextField.isEditing,
                   nicknameEditing && jobEditing == true {
                    self?.view.endEditing(true)
                    return
                }
                
                let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                sheet.addAction(UIAlertAction(title: "앨범에서 선택", style: .default) {_ in
                    guard let imagePicker = self?.imagePicker else { return }
                    self?.present(imagePicker, animated: true)
                })
                sheet.addAction(UIAlertAction(title: "기본 이미지", style: .default) { _ in
                    DispatchQueue.main.async {
                        self?.viewModel.profileImageSubject.value = nil
                    }
                })
                sheet.addAction(UIAlertAction(title: "취소", style: .cancel))
                
                self?.present(sheet, animated: true)
            }
            .store(in: &cancellables)
        
        self.fixDoneButton.publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                guard let nickname = self?.nicknameTextField.text else { return }
                guard let job = self?.jobTextField.text else { return }
                self?.viewModel.didTapDoneButton(nickname: nickname, job: job)
                
                self?.navigationController?.popViewController(animated: true)
            }
            .store(in: &cancellables)
        
        viewModel.profileImageSubject
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
}

extension FixMyInfoViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        guard let itemProvider = results.first?.itemProvider else { return }
        
        if itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, _ in
                guard let image = image as? UIImage else {
                    let alert = UIAlertController(
                        title: "선택할 수 없는 이미지입니다",
                        message: nil,
                        preferredStyle: .alert
                    )
                    
                    DispatchQueue.main.async {
                        self?.present(alert, animated: true)
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                        alert.dismiss(animated: true)
                    }
                    
                    return
                }
                
                DispatchQueue.main.async {
                    self?.viewModel.profileImageSubject.value = image
                }
            }
        }
    }
}
