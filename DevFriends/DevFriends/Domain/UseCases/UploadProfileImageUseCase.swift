//
//  UploadProfileImageUseCase.swift
//  DevFriends
//
//  Created by 상현 on 2022/11/29.
//

import Foundation

protocol UploadProfileImageUseCase {
    func execute(uid: String, image: Data) async throws
}

final class DefaultUploadProfileImageUseCase: UploadProfileImageUseCase {
    private let imageRepository: ImageRepository
    
    init(imageRepository: ImageRepository) {
        self.imageRepository = imageRepository
    }
    
    func execute(uid: String, image: Data) async throws {
        return try await imageRepository.upload(.profile, uid: uid, image: image)
    }
}
