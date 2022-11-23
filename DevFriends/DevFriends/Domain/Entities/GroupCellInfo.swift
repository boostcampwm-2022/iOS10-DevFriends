//
//  GroupCellInfo.swift
//  DevFriends
//
//  Created by 이대현 on 2022/11/19.
//

import Foundation

struct GroupCellInfo: Hashable {
    // DiffableDataSource에서 데이터 중복을 막기 위해 section 추가
    let section: GroupListSection
    let group: Group
    
    init(group: Group, at section: GroupListSection) {
        self.section = section
        self.group = group
    }
}
