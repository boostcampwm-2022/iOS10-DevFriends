//
//  ContainsRealm.swift
//  DevFriends
//
//  Created by 심주미 on 2022/11/26.
//

import RealmSwift

protocol ContainsRealm {}

extension ContainsRealm {
    var realm: Realm? {
        return try? Realm()
    }
}
