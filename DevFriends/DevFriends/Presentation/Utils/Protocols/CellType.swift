//
//  CellType.swift
//  DevFriends
//
//  Created by 심주미 on 2022/11/14.
//

import UIKit

protocol CellType {
    static var reuseIdentifier: String { get }
    func layout()
}

extension CellType where Self: UIView {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
