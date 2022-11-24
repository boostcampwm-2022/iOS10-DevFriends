//
//  ContainsFirestore.swift
//  DevFriends
//
//  Created by 유승원 on 2022/11/19.
//

import Foundation
import FirebaseFirestore

protocol ContainsFirestore {}

extension ContainsFirestore {
    var firestore: Firestore {
        return Firestore.firestore()
    }
}
