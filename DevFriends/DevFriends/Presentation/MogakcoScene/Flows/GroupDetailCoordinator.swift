//
//  GroupDetailCoordinator.swift
//  DevFriends
//
//  Created by 상현 on 2022/11/24.
//

import Foundation

// MARK: GroupDetailCoordinator가 필요할까?
protocol GroupDetailCoordinator {
    func showGroupDetailViewController(group: Group)
    func showNotificationViewController()
}
