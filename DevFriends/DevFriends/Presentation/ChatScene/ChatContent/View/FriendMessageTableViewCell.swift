//
//  FriendMessageTableViewCell.swift
//  DevFriends
//
//  Created by 심주미 on 2022/11/15.
//

import Combine
import UIKit

final class FriendMessageTableViewCell: UITableViewCell, MessageCellType, ContainsProfile, ContainsTime {
    var timeSubject = CurrentValueSubject<Date?, Error>(nil)
    var nameSubject = PassthroughSubject<String?, Error>()
    var imageSubject = PassthroughSubject<Data?, Error>()
    var cancellables = Set<AnyCancellable>()
    
    lazy var messageLabel: MessageLabel = {
        let label = MessageLabel(type: .friend)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.messageLabel.text = ""
    }
    
    func updateContent(data: Message) {
        self.messageLabel.text = data.content
        
        self.timeSubject.send(data.time)
        self.nameSubject.send(data.userNickname)
        self.imageSubject.send(UIImage.defaultProfileImage?.pngData())
        self.makeMessageTopConstraintsOffset()
    }
    
    func removeTimeLabel() {
        self.timeSubject.send(nil)
    }
    
    func removeProfileAndName() {
        self.imageSubject.send(nil)
        self.nameSubject.send(nil)
        self.removeMessageTopConstraintsOffset()
    }
    
    private func removeMessageTopConstraintsOffset() {
        self.messageLabel.snp.updateConstraints { make in
            make.top.equalToSuperview()
        }
    }
    
    private func makeMessageTopConstraintsOffset() {
        self.messageLabel.snp.updateConstraints { make in
            make.top.equalToSuperview().offset(30)
        }
    }
    
    func layout() {
        self.addSubview(messageLabel)
        self.messageLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(30)
            make.bottom.lessThanOrEqualToSuperview().offset(-10)
            make.leading.equalToSuperview().offset(80)
            make.trailing.lessThanOrEqualToSuperview().offset(-50)
        }
        self.makeTimeLabel(messageLabel: self.messageLabel, type: .friend)
        self.makeProfileView(messageLabel: self.messageLabel)
    }
}
