//
//  MyMessageTableViewCell.swift
//  DevFriends
//
//  Created by 심주미 on 2022/11/15.
//

import UIKit

final class MyMessageTableViewCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension MyMessageTableViewCell: CellType {
    static var reuseIdentifier: String = String(describing: MyMessageTableViewCell.self)
    
    func layout() {
        
    }
    
    
}
