//
//  UIViewController+HideKeyboard.swift
//  DevFriends
//
//  Created by 유승원 on 2022/11/15.
//
import UIKit

extension UIViewController {
    func hideKeyboardWhenTapped() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGestureRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
