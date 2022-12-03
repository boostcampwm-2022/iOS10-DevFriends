//
//  CommentInfo.swift
//  DevFriends
//
//  Created by 유승원 on 2022/12/03.
//

import Foundation

struct CommentInfo: Hashable {
    static func == (lhs: CommentInfo, rhs: CommentInfo) -> Bool {
        return lhs.writerInfo == rhs.writerInfo && lhs.contents == rhs.contents
    }
    
    let writerInfo: PostWriterInfo
    let contents: String
}
