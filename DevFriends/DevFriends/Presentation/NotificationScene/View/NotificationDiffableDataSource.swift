//
//  NotificationDiffableDataSource.swift
//  DevFriends
//
//  Created by 유승원 on 2022/11/23.
//

import Combine
import UIKit

final class NotificationDiffableDataSource: UITableViewDiffableDataSource<Section, Notification> {
    var notificationSubject = PassthroughSubject<Notification, Never>()
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            var snapshot = self.snapshot()
            if let notification = itemIdentifier(for: indexPath) {
                snapshot.deleteItems([notification])
                apply(snapshot, animatingDifferences: true)
                self.notificationSubject.send(notification)
            }
        }
    }
}
