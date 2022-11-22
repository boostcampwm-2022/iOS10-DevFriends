//
//  GroupCellInfo.swift
//  DevFriends
//
//  Created by 이대현 on 2022/11/19.
//

import Foundation

struct GroupCellInfo: Hashable {
    // DiffableDataSource에서 데이터 중복을 막기 위해 identifier 추가
    let identifier: String
    let group: Group
    
    init(group: Group) {
        self.identifier = UUID().uuidString
        self.group = group
    }
}
