//
//  MyGroupsViewModel.swift
//  DevFriends
//
//  Created by 심주미 on 2022/11/23.
//

import Foundation

final class MyGroupsViewModel {
    let type: MyGroupsType
    
    init(type: MyGroupsType) {
        self.type = type
    }
    
    func getMyGroupsTypeName() -> String {
        return type.rawValue
    }
}
