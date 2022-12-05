//
//  LoadProfileImageUseCase.swift
//  DevFriends
//
//  Created by 상현 on 2022/11/29.
//

import Foundation

protocol LoadProfileImageUseCase {
    func execute(path: String) async throws -> Data
}

final class DefaultLoadProfileImageUseCase: LoadProfileImageUseCase {
    private let imageRepository: ImageRepository
    
    init(imageRepository: ImageRepository) {
        self.imageRepository = imageRepository
    }
    
    func execute(path: String) async throws -> Data {
        return try await imageRepository.fetch(.profile, path: path)
    }
}
