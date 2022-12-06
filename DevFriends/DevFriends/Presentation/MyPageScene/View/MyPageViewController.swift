//
//  MyPageViewController.swift
//  DevFriends
//
//  Created by 심주미 on 2022/11/22.
//

import UIKit
import Combine

final class MyPageViewController: UIViewController {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "마이페이지"
        label.font = .systemFont(ofSize: 25, weight: .bold)
        return label
    }()
    
    private let profileImageViewHeight: CGFloat = 100
    
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .profile
        imageView.layer.cornerRadius = profileImageViewHeight / 2
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 25, weight: .bold)
        label.text = "사용자"
        return label
    }()
    
    private let preferenceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.alignment = .leading
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    private let makedGroupButton = SubtitleButton(text: "만든 모임")
    private let participatedGroupButton = SubtitleButton(text: "참여 모임")
    private let likedGroupButton = SubtitleButton(text: "관심 모임")
    
    private let fixMyInfoButton = SubtitleButton(text: "회원정보 수정")
    private let logoutButton = SubtitleButton(text: "로그아웃")
    private let withdrawalButton = SubtitleButton(text: "회원탈퇴")
    
    private var cancellables = Set<AnyCancellable>()
    
    private let viewModel: MyPageViewModel
    
    init(viewModel: MyPageViewModel) {
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
        self.setupNavigation()
    }
    
    private func bind() {
        makedGroupButton.publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                self?.viewModel.showMakedGroup()
            }
            .store(in: &cancellables)
        
        participatedGroupButton.publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                self?.viewModel.showParticipatedGroup()
            }
            .store(in: &cancellables)
        likedGroupButton.publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                self?.viewModel.showLikedGroup()
            }
            .store(in: &cancellables)
        
        fixMyInfoButton.publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                self?.viewModel.showFixMyInfo()
            }
            .store(in: &cancellables)
        
        logoutButton.publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                self?.viewModel.showLogout()
            }
            .store(in: &cancellables)
        
        withdrawalButton.publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                self?.viewModel.showWithdrawl()
            }
            .store(in: &cancellables)
        
        viewModel.userImageSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] image in
                self?.profileImageView.image = image
            }
            .store(in: &cancellables)
        
        viewModel.userNicknameSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] name in
                self?.nameLabel.text = name
            }
            .store(in: &cancellables)
        
        viewModel.userCategoriesSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] categories in
                self?.preferenceStackView.subviews.forEach({ view in
                    view.removeFromSuperview()
                })
                categories.forEach { category in
                    let label = FilledRoundTextLabel(text: category.name, backgroundColor: .devFriendsGreen, textColor: .black)
                    self?.preferenceStackView.addArrangedSubview(label)
                }
            }
            .store(in: &cancellables)
    }
    
    private func makeTitleLabel(text: String) -> UILabel {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.text = text
        return label
    }
        
    private func layout() {
        let spacing = 25
        view.addSubview(profileImageView)
        profileImageView.snp.makeConstraints { make in
            make.height.width.equalTo(profileImageViewHeight)
            make.top.leading.equalTo(view.safeAreaLayoutGuide).offset(spacing)
        }
        
        view.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView).offset(10)
            make.leading.equalTo(profileImageView.snp.trailing).offset(spacing)
        }
        
        view.addSubview(preferenceStackView)
        preferenceStackView.snp.makeConstraints { make in
            make.leading.equalTo(nameLabel)
            make.bottom.equalTo(profileImageView).offset(-10)
            make.trailing.lessThanOrEqualTo(view).offset(-spacing)
        }
        
        let divider1 = DividerView()
        view.addSubview(divider1)
        divider1.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(30)
            make.leading.equalToSuperview().offset(spacing)
            make.trailing.equalToSuperview().offset(-spacing)
        }
        
        let scrollView = UIScrollView()
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(divider1.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        let contentView = UIView()
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(view.frame.width)
        }
        
        let activityTitleLabel = makeTitleLabel(text: "내 활동")
        contentView.addSubview(activityTitleLabel)
        activityTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(30)
            make.leading.equalToSuperview().offset(spacing)
        }
        
        contentView.addSubview(makedGroupButton)
        makedGroupButton.snp.makeConstraints { make in
            make.top.equalTo(activityTitleLabel.snp.bottom).offset(spacing)
            make.leading.equalTo(activityTitleLabel)
        }
        
        contentView.addSubview(participatedGroupButton)
        participatedGroupButton.snp.makeConstraints { make in
            make.top.equalTo(makedGroupButton.snp.bottom).offset(spacing)
            make.leading.equalTo(activityTitleLabel)
        }
        
        contentView.addSubview(likedGroupButton)
        likedGroupButton.snp.makeConstraints { make in
            make.top.equalTo(participatedGroupButton.snp.bottom).offset(spacing)
            make.leading.equalTo(activityTitleLabel)
        }
        
        contentView.addSubview(withdrawalButton)
        withdrawalButton.snp.makeConstraints { make in
            make.leading.equalTo(activityTitleLabel)
            make.bottom.equalToSuperview().offset(-50)
        }
        
        contentView.addSubview(logoutButton)
        logoutButton.snp.makeConstraints { make in
            make.leading.equalTo(activityTitleLabel)
            make.bottom.equalTo(withdrawalButton.snp.top).offset(-spacing)
        }
        
        contentView.addSubview(fixMyInfoButton)
        fixMyInfoButton.snp.makeConstraints { make in
            make.leading.equalTo(activityTitleLabel)
            make.bottom.equalTo(logoutButton.snp.top).offset(-spacing)
        }
        
        let myInfoLabel = makeTitleLabel(text: "내 정보")
        contentView.addSubview(myInfoLabel)
        myInfoLabel.snp.makeConstraints { make in
            make.leading.equalTo(activityTitleLabel)
            make.bottom.equalTo(fixMyInfoButton.snp.top).offset(-spacing)
        }
        
        let divider2 = DividerView()
        contentView.addSubview(divider2)
        divider2.snp.makeConstraints { make in
            make.leading.trailing.equalTo(divider1)
            make.bottom.equalTo(myInfoLabel.snp.top).offset(-30)
            make.top.equalTo(likedGroupButton.snp.bottom).offset(50)
        }
    }
    
    private func setupNavigation() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleLabel)
    }
    
    func updateUserInfo(nickname: String, image: UIImage?, categories: [Category]) {
        viewModel.userImageSubject.value = image ?? UIImage(named: "Image")
        viewModel.userNicknameSubject.value = nickname
        viewModel.userCategoriesSubject.value = categories
    }
}
