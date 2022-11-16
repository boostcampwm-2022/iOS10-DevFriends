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
        self.addSubview(label)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateContent(data: Message, messageContentType: MessageContentType) {
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
        self.messageLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-10)
            $0.leading.greaterThanOrEqualToSuperview().offset(50)
            $0.trailing.equalToSuperview().offset(-20)
        }
        self.makeTimeLabel(messageLabel: self.messageLabel, type: .me)
    }
}
