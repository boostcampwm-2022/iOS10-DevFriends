//
//  DateTableViewCell.swift
//  DevFriends
//
//  Created by 심주미 on 2022/11/29.
//

import SnapKit
import UIKit

final class DateTableViewCell: UITableViewCell, ReusableType {
    let dateLabel = FilledRoundTextLabel(text: "", backgroundColor: .gray, textColor: .white)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layout() {
        dateLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    func set(date: Date) {
        dateLabel.text = date.toKoreanStringWithDay()
    }
}
