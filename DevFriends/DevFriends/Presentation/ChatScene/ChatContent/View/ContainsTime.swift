//
//  ContainsTime.swift
//  DevFriends
//
//  Created by 심주미 on 2022/11/16.
//

import Combine
import SnapKit
import UIKit

protocol ContainsTime: UIView {
    var timeSubject: PassthroughSubject<String?, Error> {get set}
    var cancellables: Set<AnyCancellable> {get set}
}

extension ContainsTime {
    func makeTimeLabel(messageLabel: MessageLabel, type: MessageSenderType) {
        let timeLabel: UILabel = {
            let label = UILabel()
            label.textColor = .gray
            label.text = Date.now.toTimeString()
            label.font = .systemFont(ofSize: 10, weight: .medium)
            return label
        }()
        
        self.addSubview(timeLabel)
        timeLabel.snp.makeConstraints {
            switch type {
            case .friend:
                $0.leading.equalTo(messageLabel.snp.trailing).offset(10)
            case .me:
                $0.trailing.equalTo(messageLabel.snp.leading).offset(-10)
            }
            $0.bottom.equalTo(messageLabel.snp.bottom)
        }
        
        self.bind(timeLabel: timeLabel)
    }
    
    func bind(timeLabel: UILabel) {
        timeSubject.sink { _ in
        } receiveValue: { time in
            if let time = time {
                timeLabel.isHidden = false
                timeLabel.text = time
            } else {
                timeLabel.isHidden = true
            }
        }
        .store(in: &cancellables)
    }
}
