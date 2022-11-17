//
//  UITextField+Combine.swift
//  DevFriends
//
//  Created by 심주미 on 2022/11/16.
//

import Combine
import UIKit

extension UITextField {
    var textPublisher: AnyPublisher<String?, Never> {
        NotificationCenter.default.publisher(
            for: UITextField.textDidChangeNotification,
            object: self
        )
        .map { ($0.object as? UITextField)?.text }
        .eraseToAnyPublisher()
    }
}
