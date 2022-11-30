//
//  DefaultViewController.swift
//  DevFriends
//
//  Created by 심주미 on 2022/11/14.
//

import Combine
import UIKit

class DefaultViewController: UIViewController {
    var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
        self.layout()
        self.bind()
    }
    
    func configureUI() {}
    func layout() {}
    func bind() {}
    
    func hideKeyboardWhenTappedAround() {
        let gesture = UITapGestureRecognizer()
        self.view.gesturePublisher(.tap(gesture))
            .sink { [weak self] _ in
                self?.view.endEditing(true)
                gesture.cancelsTouchesInView = false
            }
            .store(in: &cancellables)
    }
    
    func adjustViewToKeyboard() {
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification, object: nil)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] noti in
                // 키보드의 높이만큼 화면을 올려준다.
                if let keyboardFrame: NSValue = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                    let keyboardRectangle = keyboardFrame.cgRectValue
                    let keyboardHeight = keyboardRectangle.height
                    self?.view.frame.origin.y -= (keyboardHeight-(self?.tabBarController?.tabBar.frame.size.height ?? 0))
                }
            }
            .store(in: &cancellables)
    
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification, object: nil)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] noti in
                // 키보드의 높이만큼 화면을 내려준다.
                if let keyboardFrame: NSValue = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                    let keyboardRectangle = keyboardFrame.cgRectValue
                    let keyboardHeight = keyboardRectangle.height
                    self?.view.frame.origin.y += (keyboardHeight-(self?.tabBarController?.tabBar.frame.size.height ?? 0))
                }
            }
            .store(in: &cancellables)
    }
}
