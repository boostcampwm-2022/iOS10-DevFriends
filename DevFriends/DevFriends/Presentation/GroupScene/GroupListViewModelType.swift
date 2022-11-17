//
//  GroupListViewModelType.swift
//  DevFriends
//
//  Created by 상현 on 2022/11/17.
//

import Foundation

protocol GroupListViewModelType {
    
    var userCategories: [String] { get }
    
    var filteredGroups: [Group] { get set }
    var recommendGroups: [Group] { get set }
    
    var filterTrigger: Bool { get set } // @Published
    var filterAlignType: AlignType { get set }
    var filterGroupType: GroupType? { get set }
    var filterCategoryTypes: [String] { get set }
    
    func fetchFilteredGroup(
        alignType: AlignType,
        groupType: GroupType?,
        categoryType: [String]
    )
    func fetchRecommendGroup(categories: [String])
}

//final class GroupListViewModel: GroupFilterViewControllerDelegate {
//
//    func selectFilter(_ groupFilterViewController: GroupFilterViewController,
//                      didSelectAlignType alignType: AlignType,
//                      didSelectGroupType groupType: GroupType,
//                      didSelectCategoryType categoryTypes: [String])
//    ) {
//        self.filterAlignType = alignType
//        self.filterGroupType = groupType
//        self.filterCategoryTypes = categoryTypes
//
//        self.fetchFilteredGroup(
//            alignType: alignType,
//            groupType: groupType,
//            categoryType: categoryTypes
//        )
//
//        self.filterTrigger = true
//    }
//}
