//
//  MyPageViewModel.swift
//  DevFriends
//
//  Created by 심주미 on 2022/11/23.
//

import Combine
import UIKit

struct MyPageViewModelActions {
    let showMakedGroup: () -> Void
    let showParticipatedGroup: () -> Void
    let showLikedGroup: () -> Void
    
    let showFixMyInfo: (FixMyInfoStruct) -> Void
    let showPopup: (Popup) -> Void
}

protocol MyPageViewModelInput {
    func didLoadUser()
}

protocol MyPageViewModelOutput {
    var userImageSubject: CurrentValueSubject<UIImage?, Never> { get }
    var userNicknameSubject: CurrentValueSubject<String, Never> { get }
    var userCategoriesSubject: CurrentValueSubject<[Category], Never> { get }
}

final class MyPageViewModel {
    let actions: MyPageViewModelActions
    private let loadCategoryUseCase: LoadCategoryUseCase
    
    var userImageSubject = CurrentValueSubject<UIImage?, Never>(nil)
    var userNicknameSubject = CurrentValueSubject<String, Never>("사용자")
    var userCategoriesSubject = CurrentValueSubject<[Category], Never>([])
    
    init(actions: MyPageViewModelActions, loadCategoryUseCase: LoadCategoryUseCase) {
        self.actions = actions
        self.loadCategoryUseCase = loadCategoryUseCase
        
        userImageSubject.value = UserManager.shared.profile
        userNicknameSubject.value = UserManager.shared.nickname ?? "사용자"
        Task {
            if let ids = UserManager.shared.categoryIDs {
                userCategoriesSubject.value = await loadCategories(categoryIds: ids)
            }
        }
    }
    
    private func loadCategories(categoryIds: [String]) async -> [Category] {
        var categories: [Category] = []
        if !categoryIds.isEmpty {
            do {
                categories = try await loadCategoryUseCase.execute(categoryIds: categoryIds)
            } catch {
                print(error)
            }
        }
        
        return categories
    }
}

extension MyPageViewModel {
    func showMakedGroup() {
        actions.showMakedGroup()
    }
    
    func showParticipatedGroup() {
        actions.showParticipatedGroup()
    }
    
    func showLikedGroup() {
        actions.showLikedGroup()
    }
    
    func showFixMyInfo() {
        let image = userImageSubject.value == UIImage(named: "Image") ? nil : userImageSubject.value
        actions.showFixMyInfo(
            FixMyInfoStruct(
                user: UserManager.shared.user,
                image: image,
                categories: userCategoriesSubject.value
            )
        )
    }
    
    func showLogout() {
        let popup = Popup(
            title: "로그아웃",
            message: "정말 로그아웃 하시겠어요?",
            done: "로그아웃",
            close: "닫기"
        )
        actions.showPopup(popup)
    }
    
    func showWithdrawl() {
        let popup = Popup(
            title: "탈퇴하기",
            message: "계정을 삭제하면 개발친구의 모든 활동 정보가 삭제됩니다. 계정 삭제 후 7일간 다시 가입할 수 없습니다.",
            done: "탈퇴하기",
            close: "취소"
        )
        actions.showPopup(popup)
    }
}
