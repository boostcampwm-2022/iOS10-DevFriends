//
//  AppDIContainer.swift
//  DevFriends
//
//  Created by 심주미 on 2022/11/15.
//

import Foundation

final class AppDIContainer {
    
    func makeChatSceneDIContainer() -> ChatSceneDIContainer {
        return ChatSceneDIContainer()
    }
}
