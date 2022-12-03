//
//  Array+SafeIndex.swift
//  DevFriends
//
//  Created by 유승원 on 2022/12/03.
//

import Foundation

extension Array {
    subscript (safe index: Int) -> Element? {
        return indices ~= index ? self[index] : nil
    }
}
