//
//  UIViewController+Keyboard.swift
//  DevFriends
//
//  Created by 심주미 on 2022/12/03.
//

import UIKit
import Combine

extension UIViewController {
    func hideKeyboardWhenTappedAround() -> AnyCancellable {
        let gesture = UITapGestureRecognizer()
        return view.gesturePublisher(.tap(gesture))
            .sink { [weak self] _ in
                self?.view.endEditing(true)
                gesture.cancelsTouchesInView = false
            }
    }
    
    func upViewByKeyboardHeight() -> AnyCancellable {
        return NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification, object: nil)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] noti in
                // 키보드의 높이만큼 화면을 올려준다.
                if let keyboardFrame: NSValue = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                    let keyboardRectangle = keyboardFrame.cgRectValue
                    let keyboardHeight = keyboardRectangle.height
                    
                    let offset = keyboardHeight - (self?.tabBarController?.tabBar.frame.size.height ?? 0)
                    self?.view.frame.origin.y -= offset
                }
            }
    }
    
    func downViewByKeyboardHeight() -> AnyCancellable {
        return NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification, object: nil)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] noti in
                // 키보드의 높이만큼 화면을 내려준다.
                if let keyboardFrame: NSValue = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                    let keyboardRectangle = keyboardFrame.cgRectValue
                    let keyboardHeight = keyboardRectangle.height
                    
                    let offset = keyboardHeight - (self?.tabBarController?.tabBar.frame.size.height ?? 0)
                    self?.view.frame.origin.y += offset
                }
            }
    }
}
