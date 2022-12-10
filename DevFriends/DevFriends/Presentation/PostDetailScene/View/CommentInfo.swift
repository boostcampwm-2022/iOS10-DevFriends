//
//  CommentInfo.swift
//  DevFriends
//
//  Created by 유승원 on 2022/12/03.
//

import Foundation

struct CommentInfo: Hashable {
    static func == (lhs: CommentInfo, rhs: CommentInfo) -> Bool {
        return lhs.id == rhs.id
    }
    
    let id: String
    let writerInfo: PostWriterInfo
    let contents: String
}
