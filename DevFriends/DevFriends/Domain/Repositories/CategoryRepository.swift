//
//  CategoryRepository.swift
//  DevFriends
//
//  Created by 상현 on 2022/11/22.
//

import Foundation

protocol CategoryRepository: ContainsFirestore {
    func fetch() async throws -> [Category]
    func fetch(_ categoryIds: [String]) async throws -> [Category]
}
