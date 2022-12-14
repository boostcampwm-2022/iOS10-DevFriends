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
    var timeSubject: CurrentValueSubject<Date?, Error> { get set }
    var cancellables: Set<AnyCancellable> { get set }
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
        
        self.layout(timeLabel: timeLabel, messageLabel: messageLabel, type: type)
        self.bind(timeLabel: timeLabel)
    }
    
    func layout(timeLabel: UILabel, messageLabel: MessageLabel, type: MessageSenderType) {
        self.addSubview(timeLabel)
        timeLabel.snp.makeConstraints { make in
            switch type {
            case .friend:
                make.leading.equalTo(messageLabel.snp.trailing).offset(10)
            case .myself:
                make.trailing.equalTo(messageLabel.snp.leading).offset(-10)
            }
            make.bottom.equalTo(messageLabel.snp.bottom)
        }
    }
    
    func bind(timeLabel: UILabel) {
        timeSubject.sink { _ in
        } receiveValue: { time in
            if let time = time {
                timeLabel.isHidden = false
                timeLabel.text = time.toTimeString()
            } else {
                timeLabel.isHidden = true
            }
        }
        .store(in: &cancellables)
    }
}
