//
//  TabBarViewModel.swift
//  DevFriends
//
//  Created by 심주미 on 2022/11/23.
//

import Foundation

struct TabBarViewModelActions {
    let setChat: () -> Void
}

final class TabBarViewModel {
    private let actions: TabBarViewModelActions?
    
    init(actions: TabBarViewModelActions) {
        self.actions = actions
    }
}

extension TabBarViewModel {
    func showChat() {
        actions?.setChat()
    }
}
