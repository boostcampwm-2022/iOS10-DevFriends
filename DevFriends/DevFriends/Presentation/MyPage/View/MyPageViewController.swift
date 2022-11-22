//
//  MyPageViewController.swift
//  DevFriends
//
//  Created by 심주미 on 2022/11/22.
//

import UIKit

final class MyPageViewController: DefaultViewController {
    private let profileImageViewHeight: CGFloat = 100
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .profile
        imageView.layer.cornerRadius = profileImageViewHeight / 2
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 25, weight: .bold)
        label.text = "사용자"
        return label
    }()
    
    private let makedGroupButton = SubtitleButton(text: "만든 모임")
    private let participatedGroupButton = SubtitleButton(text: "참여 모임")
    private let likedGroupButton = SubtitleButton(text: "관심 모임")
    
    private let fixMyInfoButton = SubtitleButton(text: "회원정보 수정")
    private let logoutButton = SubtitleButton(text: "로그아웃")
    private let withdrawalButton = SubtitleButton(text: "회원탈퇴")
    
    override func bind() {
        fixMyInfoButton.publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                self?.showFixMyInfoViewController()
            }
            .store(in: &cancellables)
        
        logoutButton.publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                self?.showLogoutViewController()
            }
            .store(in: &cancellables)
    }
    
    func showFixMyInfoViewController() {
        let vc = FixMyInfoViewController()
        vc.view.backgroundColor = .white
        present(vc, animated: true)
    }
    
    func showLogoutViewController() {
        let vc = PopupViewController()
        vc.set(title: "로그아웃", message: "정말 로그아웃 하시겠어요?", done: "로그아웃", close: "닫기")
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: false)
        
        /*mogakcoModalViewController.modalPresentationStyle = .pageSheet
        if let sheet = mogakcoModalViewController.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
            sheet.largestUndimmedDetentIdentifier = .medium
        }
        present(mogakcoModalViewController, animated: true, completion: nil)*/
    }
    
    private func makeTitleLabel(text: String) -> UILabel {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.text = text
        return label
    }
    
    private func makePreferenceStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.alignment = .leading
        stackView.distribution = .fillProportionally
        
        ["swift", "java"].forEach { text in
            let label = FilledRoundTextLabel(text: text, backgroundColor: .devFriendsGreen, textColor: .black)
            stackView.addArrangedSubview(label)
        }
        
        return stackView
    }
    
    override func layout() {
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
        
        let stackView = makePreferenceStackView()
        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
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
        
        let activityTitleLabel = makeTitleLabel(text: "내 활동")
        view.addSubview(activityTitleLabel)
        activityTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(divider1.snp.bottom).offset(30)
            make.leading.equalToSuperview().offset(spacing)
        }
        
        view.addSubview(makedGroupButton)
        makedGroupButton.snp.makeConstraints { make in
            make.top.equalTo(activityTitleLabel.snp.bottom).offset(spacing)
            make.leading.equalTo(activityTitleLabel)
        }
        
        view.addSubview(participatedGroupButton)
        participatedGroupButton.snp.makeConstraints { make in
            make.top.equalTo(makedGroupButton.snp.bottom).offset(spacing)
            make.leading.equalTo(activityTitleLabel)
        }
        
        view.addSubview(likedGroupButton)
        likedGroupButton.snp.makeConstraints { make in
            make.top.equalTo(participatedGroupButton.snp.bottom).offset(spacing)
            make.leading.equalTo(activityTitleLabel)
        }
        
        view.addSubview(withdrawalButton)
        withdrawalButton.snp.makeConstraints { make in
            make.leading.equalTo(activityTitleLabel)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-50)
        }
        
        view.addSubview(logoutButton)
        logoutButton.snp.makeConstraints { make in
            make.leading.equalTo(activityTitleLabel)
            make.bottom.equalTo(withdrawalButton.snp.top).offset(-spacing)
        }
        
        view.addSubview(fixMyInfoButton)
        fixMyInfoButton.snp.makeConstraints { make in
            make.leading.equalTo(activityTitleLabel)
            make.bottom.equalTo(logoutButton.snp.top).offset(-spacing)
        }
        
        let myInfoLabel = makeTitleLabel(text: "내 정보")
        view.addSubview(myInfoLabel)
        myInfoLabel.snp.makeConstraints { make in
            make.leading.equalTo(activityTitleLabel)
            make.bottom.equalTo(fixMyInfoButton.snp.top).offset(-spacing)
        }
        
        let divider2 = DividerView()
        view.addSubview(divider2)
        divider2.snp.makeConstraints { make in
            make.leading.trailing.equalTo(divider1)
            make.bottom.equalTo(myInfoLabel.snp.top).offset(-30)
        }
    }
}
