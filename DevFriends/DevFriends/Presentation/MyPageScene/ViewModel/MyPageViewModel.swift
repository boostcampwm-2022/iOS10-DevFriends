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
    
    let showLoginView: () -> Void
}

protocol MyPageViewModelInput {
    func didTapMakedGroup()
    func didTapParticipatedGroup()
    func didTapLikedGroup()
    func didTapFixMyInfo()
    func didTapLogout()
    func didTapWithdrawal()
}

protocol MyPageViewModelOutput {
    var userImageSubject: CurrentValueSubject<UIImage?, Never> { get }
    var userNicknameSubject: CurrentValueSubject<String, Never> { get }
    var userCategoriesSubject: CurrentValueSubject<[Category], Never> { get }
}

protocol MyPageViewModel: MyPageViewModelInput, MyPageViewModelOutput {}

final class DefaultMyPageViewModel: MyPageViewModel {
    let actions: MyPageViewModelActions
    private let loadCategoryUseCase: LoadCategoryUseCase
    private let withdrawUseCase: WithdrawUseCase
    private let myInfoRepository: MyInfoRepository
    
    var userImageSubject = CurrentValueSubject<UIImage?, Never>(nil)
    var userNicknameSubject = CurrentValueSubject<String, Never>("사용자")
    var userCategoriesSubject = CurrentValueSubject<[Category], Never>([])
    
    init(actions: MyPageViewModelActions, loadCategoryUseCase: LoadCategoryUseCase, withdrawUseCase: WithdrawUseCase, myInfoRepository: MyInfoRepository) {
        self.actions = actions
        self.loadCategoryUseCase = loadCategoryUseCase
        self.withdrawUseCase = withdrawUseCase
        self.myInfoRepository = myInfoRepository
        
        userImageSubject.value = myInfoRepository.profile
        userNicknameSubject.value = myInfoRepository.nickname ?? "사용자"
        Task {
            if let ids = myInfoRepository.categoryIDs {
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
    
    private func logoutAction() {
        myInfoRepository.logout()
        actions.showLoginView()
    }
    
    private func withdrawalAction() {
        guard
            let userID = myInfoRepository.uid,
            let joinedGroupIDs = myInfoRepository.joinedGroupIDs
        else {
            myInfoRepository.logout()
            actions.showLoginView()
            
            return
        }
        
        myInfoRepository.logout()
    
        withdrawUseCase.execute(userID: userID, joinedGroupIDs: joinedGroupIDs)
        actions.showLoginView()
    }
}

extension DefaultMyPageViewModel {
    func didTapMakedGroup() {
        actions.showMakedGroup()
    }
    
    func didTapParticipatedGroup() {
        actions.showParticipatedGroup()
    }
    
    func didTapLikedGroup() {
        actions.showLikedGroup()
    }
    
    func didTapFixMyInfo() {
        let image = userImageSubject.value == UIImage(named: "Image") ? nil : userImageSubject.value
        actions.showFixMyInfo(
            FixMyInfoStruct(
                user: myInfoRepository.user,
                image: image,
                categories: userCategoriesSubject.value
            )
        )
    }
    
    func didTapLogout() {
        let popup = Popup(
            title: "로그아웃",
            message: "정말 로그아웃 하시겠어요?",
            done: "로그아웃",
            close: "닫기",
            doneAction: logoutAction
        )
        actions.showPopup(popup)
    }
    
    func didTapWithdrawal() {
        let popup = Popup(
            title: "탈퇴하기",
            message: "계정을 삭제하면 개발친구의 모든 활동 정보가 삭제됩니다. 계정 삭제 후 7일간 다시 가입할 수 없습니다.",
            done: "탈퇴하기",
            close: "취소",
            doneAction: withdrawalAction
        )
        actions.showPopup(popup)
    }
}
