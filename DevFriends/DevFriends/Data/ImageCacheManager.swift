//
//  ImageCacheManager.swift
//  DevFriends
//
//  Created by 심주미 on 2022/12/11.
//

import Foundation

final class ImageCacheManager {
    static let shared = ImageCacheManager()
    private let cache = NSCache<NSString, NSData>()
    
    private init() {}
    
    func fetch(id: String) -> Data? {
        guard let data = cache.object(forKey: id as NSString) else {
            return nil
        }
        return data as Data
    }
    
    func save(id: String, data: Data) {
        cache.setObject(data as NSData, forKey: id as NSString)
    }
}
