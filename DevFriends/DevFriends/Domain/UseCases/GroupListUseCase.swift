//
//  GroupListUseCase.swift
//  DevFriends
//
//  Created by 이대현 on 2022/11/19.
//

import Foundation

final class GroupListUseCase {
    func fetchRecommandGroups() -> [GroupCellInfo] {
        var groups: [GroupCellInfo] = []
        groups.append(GroupCellInfo(title: "같이 C언어 하실 분?", categories: ["C언어"], place: "네이버 1784", currentPeople: 1, peopleLimit: 4))
        groups.append(GroupCellInfo(title: "iOS 토이 프로젝트 같이 하실 분 구해요", categories: ["Swift", "프로젝트"], place: "강남 스터디카페", currentPeople: 3, peopleLimit: 4))
        groups.append(GroupCellInfo(title: "Combine 내가 다 알려줄게 들어와", categories: ["Swift", "Combine"], place: "영등포 타임스퀘어", currentPeople: 4, peopleLimit: 5))
        return groups
    }
    
    func fetchAllGroups() -> [GroupCellInfo] {
        var groups: [GroupCellInfo] = []
        groups.append(GroupCellInfo(title: "같이 C언어 하실 분?", categories: ["C언어"], place: "네이버 1784", currentPeople: 1, peopleLimit: 4))
        groups.append(GroupCellInfo(title: "iOS 토이 프로젝트 같이 하실 분 구해요", categories: ["Swift", "프로젝트"], place: "강남 스터디카페", currentPeople: 3, peopleLimit: 4))
        groups.append(GroupCellInfo(title: "Combine 내가 다 알려줄게 들어와", categories: ["Swift", "Combine"], place: "영등포 타임스퀘어", currentPeople: 4, peopleLimit: 5))
        groups.append(GroupCellInfo(title: "Kotlin 형은 나가있어", categories: ["Swift", "Combine"], place: "영등포 타임스퀘어", currentPeople: 4, peopleLimit: 5))
        return groups
    }
}
