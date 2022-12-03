//
//  UITextView+Combine.swift
//  DevFriends
//
//  Created by 이대현 on 2022/11/30.
//

import Combine
import UIKit

extension UITextView {
    var textPublisher: AnyPublisher<String?, Never> {
        NotificationCenter.default.publisher(
            for: UITextView.textDidChangeNotification,
            object: self
        )
        .map { ($0.object as? UITextView)?.text }
        .eraseToAnyPublisher()
    }
}
