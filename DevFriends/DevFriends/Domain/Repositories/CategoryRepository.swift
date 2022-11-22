//
//  CategoryRepository.swift
//  DevFriends
//
//  Created by 이대현 on 2022/11/22.
//

import Foundation

protocol CategoryRepository {
    func fetch() async throws -> [Category]
}
