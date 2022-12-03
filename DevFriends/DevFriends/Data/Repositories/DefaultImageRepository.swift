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
        let url = try await storage.reference(forURL: "\(basePath)/\(type.rawValue)/\(path)").downloadURL()
        return try NSData(contentsOf: url) as Data
    }
    
    func update(_ type: ImageType, uid: String, image: Data) {
        let metaData = StorageMetadata()
        metaData.contentType = "image/png"
        
        storage.reference().child(type.rawValue).child(uid).putData(image, metadata: metaData) { _, error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
}
