//
//  FriendMessageTableViewCell.swift
//  DevFriends
//
//  Created by 심주미 on 2022/11/15.
//

import UIKit

class FriendMessageTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        layout()
    }

}

extension FriendMessageTableViewCell: CellType {
    static var reuseIdentifier = String(describing: FriendMessageTableViewCell.self)
    
    func layout() {
        
    }
}
