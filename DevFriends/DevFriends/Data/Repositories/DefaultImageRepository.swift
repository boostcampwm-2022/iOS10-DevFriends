//
//  DefaultImageRepository.swift
//  DevFriends
//
//  Created by 상현 on 2022/11/29.
//

import Foundation
import FirebaseStorage

final class DefaultImageRepository: ImageRepository {
    private let storage = Storage.storage()
    private let basePath = "gs://devfriends-b75e3.appspot.com/"
    
    func fetch(_ type: ImageType, path: String) async throws -> Data {
        let url = try await storage.reference(forURL: "\(basePath)/\(type.rawValue)/\(path)").downloadURL()
        return try NSData(contentsOf: url) as Data
    }
    
    func upload(_ type: ImageType, uid: String, image: Data) async throws {
        let metaData = StorageMetadata()
        metaData.contentType = "image/png"
        
        storage.reference().child(type.rawValue).child(uid).putData(image, metadata: metaData) { _, error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
}
