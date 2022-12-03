//
//  UICollectionVIew+RegisterCell.swift
//  DevFriends
//
//  Created by 유승원 on 2022/12/04.
//

import UIKit

extension UICollectionView {
    func register<T: UICollectionViewCell & ReusableType>(cellType: T.Type) {
        self.register(T.self, forCellWithReuseIdentifier: T.reuseIdentifier)
    }
}
