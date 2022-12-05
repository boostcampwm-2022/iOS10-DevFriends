//
//  SortGroupUseCase.swift
//  DevFriends
//
//  Created by 이대현 on 2022/12/03.
//

import Foundation

protocol SortGroupUseCase {
    func execute(groups: [Group], by filter: AlignType, userLocation: Location?) -> [Group]
}

final class DefaultSortGroupUseCase: SortGroupUseCase {
    func execute(groups: [Group], by filter: AlignType, userLocation: Location?) -> [Group] {
        var sortedGroups = groups
        switch filter {
        case .newest:
            sortedGroups = groups.sorted(by: { $0.time > $1.time })
        case .closest:
            if let userLocation = userLocation {
                sortedGroups = groups.sorted {
                    $0.location.distance(from: userLocation) < $1.location.distance(from: userLocation)
                }
            } else {
                sortedGroups = groups.sorted(by: { $0.time > $1.time })
            }
        }
        return sortedGroups
    }
}
