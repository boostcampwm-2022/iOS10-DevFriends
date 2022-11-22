//
//  NotificationViewModel.swift
//  DevFriends
//
//  Created by 유승원 on 2022/11/22.
//

import Combine
import Foundation

protocol NotificationViewModelIntput {
    func didLoadNotifications()
}

protocol NotificationViewModelOutput {
    var notificationsSubject: CurrentValueSubject<[Notification], Never> { get }
}

protocol NotificationViewModel: NotificationViewModelIntput, NotificationViewModelOutput {}

final class DefaultNotificationViewModel: NotificationViewModel {
    private let loadNotificationsUseCase: LoadNotificationsUseCase
    
    init(loadNotificationsUseCase: LoadNotificationsUseCase) {
        self.loadNotificationsUseCase = loadNotificationsUseCase
    }
    
    // MARK: OUTPUT
    var notificationsSubject = CurrentValueSubject<[Notification], Never>([])
    
    // MARK: Private
    private func loadNotifications() async {
        let loadTask = Task {
            return try await loadNotificationsUseCase.execute()
        }
        
        let result = await loadTask.result
        
        do {
            notificationsSubject.send(try result.get())
        } catch {
            print(error)
        }
    }
}

// MARK: INPUT
extension DefaultNotificationViewModel {
    func didLoadNotifications() {
        Task {
            await self.loadNotifications()
        }
    }
}
