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
}
