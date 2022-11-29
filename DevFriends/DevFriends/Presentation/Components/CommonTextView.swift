//
//  CommonTextView.swift
//  DevFriends
//
//  Created by 이대현 on 2022/11/27.
//

import UIKit

final class CommonTextView: UITextView {
    var placeholder: String?
    
    required init?(coder: NSCoder) {
        fatalError("Init Error")
    }
    
    init(placeHolder: String?) {
        super.init(frame: .zero, textContainer: nil)
        
        self.placeholder = placeHolder
        self.style()
    }
    
    private func style() {
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.7).cgColor
        self.textContainerInset = UIEdgeInsets(top: 16.0, left: 16.0, bottom: 16.0, right: 16.0)
        self.font = .systemFont(ofSize: 18)
        self.text = placeholder
        self.textColor = .lightGray
        self.delegate = self
    }
}

extension CommonTextView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if self.text == placeholder {
            self.text = nil
            self.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if self.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            self.text = placeholder
            self.textColor = .lightGray
        }
    }
}
