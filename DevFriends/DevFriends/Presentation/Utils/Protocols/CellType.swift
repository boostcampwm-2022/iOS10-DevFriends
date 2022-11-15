//
//  CellType.swift
//  DevFriends
//
//  Created by 심주미 on 2022/11/14.
//

import Foundation

protocol CellType {
    static var reuseIdentifier: String { get }
    func layout()
}
