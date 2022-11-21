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
    let title: String
    let categories: [String]
    let place: String
    let currentPeople: Int
    let peopleLimit: Int
    
    init(title: String, categories: [String], place: String, currentPeople: Int, peopleLimit: Int) {
        self.identifier = UUID().uuidString
        self.title = title
        self.categories = categories
        self.place = place
        self.currentPeople = currentPeople
        self.peopleLimit = peopleLimit
    }
}
