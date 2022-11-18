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
    
    var timeSubject = PassthroughSubject<String?, Error>()
    var cancellables = Set<AnyCancellable>()
    
    lazy var messageLabel: MessageLabel = {
        let label = MessageLabel(type: .me)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(data: Message, messageContentType: MessageContentType) {
        self.messageLabel.text = data.content
        
        switch messageContentType {
        case .time:
            self.timeSubject.send(data.time.toTimeString())
        case .none:
            self.timeSubject.send(nil)
        default:
            break
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
