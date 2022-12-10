//
//  CategoryCacheManager.swift
//  DevFriends
//
//  Created by 심주미 on 2022/12/10.
//

import Foundation

final class CategoryCacheManager {
    static let shared = CategoryCacheManager()
    private let cache = NSCache<NSString, NSString>()
    
    private init() {}
    
    func fetch(id: String) -> Category? {
        guard let name = cache.object(forKey: id as NSString) else {
            return nil
        }
        return Category(id: id, name: name as String)
    }
    
    func save(category: Category) {
        cache.setObject(category.name as NSString, forKey: category.id as NSString)
    }
}
