//
//  CategoryRepository.swift
//  DevFriends
//
//  Created by 상현 on 2022/11/22.
//

protocol CategoryRepository {
    func fetch() async throws -> [Category]
    func fetch(_ categoryIds: [String]) async throws -> [Category]
    func fetch() async throws -> [String: Category]
}
