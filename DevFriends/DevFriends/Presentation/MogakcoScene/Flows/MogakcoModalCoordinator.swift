//
//  MogakcoModalCoordinator.swift
//  DevFriends
//
//  Created by 상현 on 2022/11/26.
//

import Foundation

protocol MogakcoModalCoordinator {
    func showMogakcoModal(mogakcos: [Group])
    func selectMogakco(index: Int)
}
