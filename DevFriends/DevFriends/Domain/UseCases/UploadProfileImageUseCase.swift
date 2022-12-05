//
//  UploadProfileImageUseCase.swift
//  DevFriends
//
//  Created by 상현 on 2022/11/29.
//

import Foundation

protocol UploadProfileImageUseCase {
    func execute(uid: String, originImage: Data, thumbnailImage: Data)
}

final class DefaultUploadProfileImageUseCase: UploadProfileImageUseCase {
    private let imageRepository: ImageRepository
    
    init(imageRepository: ImageRepository) {
        self.imageRepository = imageRepository
    }
    
    func execute(uid: String, originImage: Data, thumbnailImage: Data) {
        imageRepository.update(.profile, uid: uid, image: originImage)
        imageRepository.update(.profile, uid: uid + "_th", image: thumbnailImage)
    }
}
