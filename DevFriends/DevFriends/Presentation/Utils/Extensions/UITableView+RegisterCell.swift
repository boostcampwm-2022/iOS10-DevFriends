//
//  UITableView+RegisterCell.swift
//  DevFriends
//
//  Created by 유승원 on 2022/12/03.
//

import UIKit

extension UITableView {
    func register<T: UITableViewCell & ReusableType>(cellType: T.Type) {
        self.register(T.self, forCellReuseIdentifier: T.reuseIdentifier)
    }
}
