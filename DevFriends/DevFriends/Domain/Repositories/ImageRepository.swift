//
//  ImageRepository.swift
//  DevFriends
//
//  Created by 상현 on 2022/11/29.
//

import Foundation

enum ImageType: String {
    case profile = "profileImage"
    case group = "groupImage"
}

protocol ImageRepository {
    func fetch(_ type: ImageType, path: String) async throws -> Data
    func update(_ type: ImageType, uid: String, image: Data)
}
