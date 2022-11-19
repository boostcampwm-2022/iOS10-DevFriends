//
//  GroupListCellRepository.swift
//  DevFriends
//
//  Created by 이대현 on 2022/11/20.
//

import Foundation
import FirebaseFirestore

final class GroupListCellRepository {
    let firestore = Firestore.firestore()
    func fetchGroupList() async throws -> [GroupCellInfo] {
        var groupList: [GroupCellInfo] = []
        let groupListSnapshot = try await firestore.collection("Group").getDocuments()
        let documents = groupListSnapshot.documents
        for document in documents {
            let group = document.data()
            guard let title = group["title"] as? String,
                  let categories = group["categories"] as? [String], /*TODO: 카테고리 ID 추가 파싱 해주어야 해*/
                  let place = group["title"] as? String, /*TODO: 위도, 경도 -> 지역명으로 바꿔주어야 해*/
                  let currentPeople = group["currentNumberPeople"] as? Int,
                  let peopleLimit = group["limitedNumberPeople"] as? Int else {
                fatalError("Group data Fetching Error !!")
            }
            groupList.append(
                GroupCellInfo(
                    title: title,
                    categories: categories,
                    place: place,
                    currentPeople: currentPeople,
                    peopleLimit: peopleLimit))
        }
        return groupList
    }
}
