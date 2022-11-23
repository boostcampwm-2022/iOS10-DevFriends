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
    func didAcceptedParticipant(index: Int)
}

protocol NotificationViewModelOutput {
    var notificationsSubject: CurrentValueSubject<[Notification], Never> { get }
}

protocol NotificationViewModel: NotificationViewModelIntput, NotificationViewModelOutput {}

final class DefaultNotificationViewModel: NotificationViewModel {
    private let loadNotificationsUseCase: LoadNotificationsUseCase
    private let updateNotificationIsOKToTrueUseCase: UpdateNotificationIsOKToTrueUseCase
    private let sendNotificationToParticipantUseCase: SendNotificationToParticipantUseCase
    private let updateGroupParticipantIDsToAddUseCase: UpdateGroupParticipantIDsToAddUseCase
    private let updateUserGroupsToAddGroupUseCase: UpdateUserGroupsToAddGroupUseCase
    
    init(
        loadNotificationsUseCase: LoadNotificationsUseCase,
        updateNotificationIsOKToTrueUseCase: UpdateNotificationIsOKToTrueUseCase,
        sendNotificationToParticipantUseCase: SendNotificationToParticipantUseCase,
        updateGroupParticipantIDsToAddUseCase: UpdateGroupParticipantIDsToAddUseCase,
        updateUserGroupsToAddGroupUseCase: UpdateUserGroupsToAddGroupUseCase
    ) {
        self.loadNotificationsUseCase = loadNotificationsUseCase
        self.updateNotificationIsOKToTrueUseCase = updateNotificationIsOKToTrueUseCase
        self.sendNotificationToParticipantUseCase = sendNotificationToParticipantUseCase
        self.updateGroupParticipantIDsToAddUseCase = updateGroupParticipantIDsToAddUseCase
        self.updateUserGroupsToAddGroupUseCase = updateUserGroupsToAddGroupUseCase
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
    
    func didAcceptedParticipant(index: Int) {
        // 1. 호스트의 Notification의 isOK를 True로 업데이트해야 함.
        let notification = self.notificationsSubject.value[index]
        guard let senderID = notification.senderID else { fatalError("Notification ID is nil") }
        updateNotificationIsOKToTrueUseCase.execute(notification: notification)
        
        // 2. 참여 대기자한테 승인되었다는 Notification을 보내야 함.
        sendNotificationToParticipantUseCase.execute(
            groupID: notification.groupID,
            senderID: senderID,
            groupTitle: notification.groupTitle,
            type: .accepted
        )
        
        Task {
            do {
                // 3. Group의 participantIDs에 참여 대기자의 ID를 넣어야 함.
                try await updateGroupParticipantIDsToAddUseCase.execute(
                    groupID: notification.groupID,
                    senderID: senderID
                )
                // 4. 참여 대기자의 User 정보의 Group에 참가할 GroupID를 넣어야 함.
                try await updateUserGroupsToAddGroupUseCase.execute(
                    groupID: notification.groupID,
                    senderID: senderID
                )
            } catch {
                print(error)
            }
        }
    }
}
