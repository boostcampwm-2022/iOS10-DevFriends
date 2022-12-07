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
    let title: String
    let categories: [Category]
    let location: Location
    let distance: Double?
    let currentNumberPeople: Int
    let limitedNumberPeople: Int
    
    init(
        section: GroupListSection,
        title: String,
        categories: [Category],
        location: Location,
        distance: Double?,
        currentNumberPeople: Int,
        limitedNumberPeople: Int
    ) {
        self.section = section
        self.title = title
        self.categories = categories
        self.location = location
        self.distance = distance
        self.currentNumberPeople = currentNumberPeople
        self.limitedNumberPeople = limitedNumberPeople
    }
}
