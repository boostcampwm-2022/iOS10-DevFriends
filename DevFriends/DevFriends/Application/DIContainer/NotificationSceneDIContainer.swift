//
//  NotificationSceneDIContainer.swift
//  DevFriends
//
//  Created by 유승원 on 2022/11/22.
//

import UIKit

protocol NotificationSceneDIContainer {}

extension NotificationSceneDIContainer {
    // MARK: Repositories
    private func makeUserRepository() -> UserRepository {
        return DefaultUserRepository()
    }
    
    private func makeNotificationRepository() -> NotificationRepository {
        return DefaultNotificationRepository()
    }
    
    private func makeGroupRepository() -> GroupRepository {
        return DefaultGroupRepository()
    }
    
    private func makeMyInfoRepository() -> MyInfoRepository {
        return UserManager.shared
    }
    
    // MARK: UseCases
    private func makeLoadNotificationsUseCase() -> LoadNotificationsUseCase {
        return DefaultLoadNotificationsUseCase(
            notificationRepository: makeNotificationRepository(),
            myInfoRepository: makeMyInfoRepository()
        )
    }
    
    private func makeUpdateNotificationIsAcceptedToTrueUseCase() -> UpdateNotificationIsAcceptedToTrueUseCase {
        return DefaultUpdateNotificationIsAcceptedToTrueUseCase(
            notificationRepository: makeNotificationRepository(),
            myInfoRepository: makeMyInfoRepository()
        )
    }
    
    private func makeSendNotificationToParticipantUseCase() -> SendNotificationToParticipantUseCase {
        return DefaultSendNotificationToParticipantUseCase(notificationRepository: makeNotificationRepository())
    }
    
    private func makeUpdateGroupParticipantIDsToAddUseCase() -> UpdateGroupParticipantIDsToAddUseCase {
        return DefaultUpdateGroupParticipantIDsToAddUseCase(groupRepository: makeGroupRepository())
    }
    
    private func makeUpdateUserGroupsToAddGroupUseCase() -> UpdateUserGroupsToAddGroupUseCase {
        return DefaultUpdateUserGroupsToAddGroupUseCase(userRepository: makeUserRepository())
    }
    
    private func makeDeleteNotificationUseCase() -> DeleteNotificationUseCase {
        return DefaultDeleteNotificationUseCase(
            notificationRepository: makeNotificationRepository(),
            myInfoRepository: makeMyInfoRepository()
        )
    }
    
    // MARK: Notification
    private func makeNotificationViewModel(actions: NotificationViewModelActions) -> NotificationViewModel {
        return DefaultNotificationViewModel(
            loadNotificationsUseCase: makeLoadNotificationsUseCase(),
            updateNotificationIsAcceptedToTrueUseCase: makeUpdateNotificationIsAcceptedToTrueUseCase(),
            sendNotificationToParticipantUseCase: makeSendNotificationToParticipantUseCase(),
            updateGroupParticipantIDsToAddUseCase: makeUpdateGroupParticipantIDsToAddUseCase(),
            updateUserGroupsToAddGroupUseCase: makeUpdateUserGroupsToAddGroupUseCase(),
            deleteNotificationUseCase: makeDeleteNotificationUseCase(),
            actions: actions
        )
    }
    
    func makeNotificationViewController(actions: NotificationViewModelActions) -> NotificationViewController {
        return NotificationViewController(notificationViewModel: makeNotificationViewModel(actions: actions))
    }
}
