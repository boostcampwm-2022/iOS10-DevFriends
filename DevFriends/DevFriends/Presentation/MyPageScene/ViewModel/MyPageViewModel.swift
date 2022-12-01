//
//  MyPageViewModel.swift
//  DevFriends
//
//  Created by 심주미 on 2022/11/23.
//

import Foundation

struct MyPageViewModelActions {
    let showMakedGroup: () -> Void
    let showParticipatedGroup: () -> Void
    let showLikedGroup: () -> Void
    
    let showFixMyInfo: () -> Void
    let showPopup: (Popup) -> Void
}

final class MyPageViewModel {
    let actions: MyPageViewModelActions
    
    init(actions: MyPageViewModelActions) {
        self.actions = actions
    }
}

extension MyPageViewModel {
    func showMakedGroup() {
        actions?.showMakedGroup()
    }
    
    func showParticipatedGroup() {
        actions?.showParticipatedGroup()
    }
    
    func showLikedGroup() {
        actions?.showLikedGroup()
    }
    
    func showFixMyInfo() {
        actions?.showFixMyInfo()
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
