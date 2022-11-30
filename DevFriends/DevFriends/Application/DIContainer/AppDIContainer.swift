//
//  AppDIContainer.swift
//  DevFriends
//
//  Created by 심주미 on 2022/11/15.
//

import Foundation

final class AppDIContainer {
    func authSceneDIContainer() -> AuthSceneDIContainer {
        return AuthSceneDIContainer()
    }
    
    func tabBarSceneDIContainer() -> TabBarSceneDIContainer {
        return TabBarSceneDIContainer()
    }
}
