//
//  MyMessageTableViewCell.swift
//  DevFriends
//
//  Created by 심주미 on 2022/11/15.
//

import Combine
import SnapKit
import UIKit

final class MyMessageTableViewCell: UITableViewCell, MessageCellType, ContainsTime {
    // TODO: private을 사용하고 싶은데 어떻게 안될까요?
    var timeSubject = CurrentValueSubject<Date?, Error>(nil)
    var cancellables = Set<AnyCancellable>()
    
    var time: Date? {
        return timeSubject.value
    }
    
    lazy var messageLabel: MessageLabel = {
        let label = MessageLabel(type: .me)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateContent(data: Message) {
        self.messageLabel.text = data.content
        self.timeSubject.send(data.time)
    }
    
    func setTimeLabel(isHidden: Bool) {
        // TODO: 이건 사실 숨기는 게 아니라 시간 값을 없애는건데 현재 만들어놓은 코드에서는 timeLabel에 접근할 수 없어 임시방편으로 처리함
        if isHidden {
            self.timeSubject.send(nil)
            // timeLabel.isHidden = true
        } else {
            // timeLabel.isHidden = false
        }
    }
    
    func layout() {
        self.addSubview(messageLabel)
        self.messageLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().offset(-10)
            make.leading.greaterThanOrEqualToSuperview().offset(50)
            make.trailing.equalToSuperview().offset(-20)
        }
        self.makeTimeLabel(messageLabel: self.messageLabel, type: .me)
    }
}
