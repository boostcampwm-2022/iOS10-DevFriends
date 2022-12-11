//
//  DefaultImageRepository.swift
//  DevFriends
//
//  Created by 상현 on 2022/11/29.
//

import FirebaseStorage

final class DefaultImageRepository: ContainsStorage {}
    
extension DefaultImageRepository: ImageRepository {
    func fetch(_ type: ImageType, path: String) async throws -> Data {
        if let data = ImageCacheManager.shared.fetch(id: path) {
            return data
        }
        let url = try await storage.reference(forURL: "\(basePath)/\(type.rawValue)/\(path)").downloadURL()
        let data = try NSData(contentsOf: url) as Data
        ImageCacheManager.shared.save(id: path, data: data)
        return data
    }
    
    func update(_ type: ImageType, path: String, image: Data) {
        let metaData = StorageMetadata()
        metaData.contentType = "image/png"
        
        storage.reference().child(type.rawValue).child(path).putData(image, metadata: metaData) { _, error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                ImageCacheManager.shared.save(id: path, data: image)
            }
        }
    }
}
