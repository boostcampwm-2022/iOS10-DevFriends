//
//  UserRepository.swift
//  DevFriends
//
//  Created by 유승원 on 2022/11/18.
//

import Foundation

protocol UserRepository: ContainsFirestore {
    func fetchUser() async throws -> User
}
