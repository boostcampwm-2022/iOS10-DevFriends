//
//  GroupListViewCoordinator.swift
//  DevFriends
//
//  Created by 이대현 on 2022/11/24.
//

import Foundation

protocol GroupListViewCoordinator: AnyObject {
    func showGroupFilterViewController(filter: Filter)
    func showNotificationViewController()
}
