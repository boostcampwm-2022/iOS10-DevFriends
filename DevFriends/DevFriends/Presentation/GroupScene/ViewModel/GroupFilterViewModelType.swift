//
//  GroupFilterViewModelType.swift
//  DevFriends
//
//  Created by 상현 on 2022/11/17.
//

import Foundation
import Combine

enum AlignType: String, CaseIterable {
    case closest = "거리순"
    case newest = "최신순"
}

enum GroupType: String, CaseIterable {
    case study = "스터디"
    case project = "프로젝트"
    case mogakco = "모각코"
}

protocol GroupFilterViewModelType {
    var selectedAlignType: AlignType { get set }
    var selectedGroupType: GroupType? { get set }
    var selectedCategoryTypes: [String] { get set }
    
    var alignType: [AlignType] { get set }
    var groupType: [GroupType] { get set }
    var categoryType: [String] { get set }
    
    func fetchCategoryType()
}

