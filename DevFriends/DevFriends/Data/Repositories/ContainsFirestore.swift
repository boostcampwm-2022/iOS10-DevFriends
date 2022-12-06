//
//  ContainsFirestore.swift
//  DevFriends
//
//  Created by 유승원 on 2022/11/19.
//

import FirebaseFirestore

enum FirestorePath: String {
    case category = "Category"
    case chat = "Chat"
    case comment = "Comment"
    case group = "Group"
    case message = "Message"
    case notification = "Notification"
    case user = "User"
}

protocol ContainsFirestore {}

extension ContainsFirestore {
    var firestore: Firestore {
        return Firestore.firestore()
    }
}
