//
//  ContainsStorage.swift
//  DevFriends
//
//  Created by 상현 on 2022/12/03.
//

import FirebaseStorage

protocol ContainsStorage {}

extension ContainsStorage {
    var basePath: String { "gs://devfriends-b75e3.appspot.com/" }
    
    var storage: Storage {
        return Storage.storage()
    }
}
