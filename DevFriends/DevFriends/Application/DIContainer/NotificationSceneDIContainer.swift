//
//  NotificationSceneDIContainer.swift
//  DevFriends
//
//  Created by 유승원 on 2022/11/22.
//

import Foundation

struct NotificationSceneDIContainer {}

extension NotificationSceneDIContainer {
    // MARK: Repositories
    func makeUserRepository() -> UserRepository {
        return DefaultUserRepository()
    }
    
    func makeNotificationRepository() -> NotificationRepository {
        return DefaultNotificationRepository()
    }
    
    func makeGroupRepository() -> GroupRepository {
        return DefaultGroupRepository()
    }
    
    // MARK: UseCases
    func makeLoadNotificationsUseCase() -> LoadNotificationsUseCase {
        return DefaultLoadNotificationsUseCase(notificationRepository: makeNotificationRepository())
    }
    
    func makeUpdateNotificationIsAcceptedToTrueUseCase() -> UpdateNotificationIsAcceptedToTrueUseCase {
        return DefaultUpdateNotificationIsAcceptedToTrueUseCase(notificationRepository: makeNotificationRepository())
    }
    
    func makeSendNotificationToParticipantUseCase() -> SendNotificationToParticipantUseCase {
        return DefaultSendNotificationToParticipantUseCase(notificationRepository: makeNotificationRepository())
    }
    
    func makeUpdateGroupParticipantIDsToAddUseCase() -> UpdateGroupParticipantIDsToAddUseCase {
        return DefaultUpdateGroupParticipantIDsToAddUseCase(groupRepository: makeGroupRepository())
    }
    
    func makeUpdateUserGroupsToAddGroupUseCase() -> UpdateUserGroupsToAddGroupUseCase {
        return DefaultUpdateUserGroupsToAddGroupUseCase(userRepository: makeUserRepository())
    }
    
    func makeDeleteNotificationUseCase() -> DeleteNotificationUseCase {
        return DefaultDeleteNotificationUseCase(notificationRepository: makeNotificationRepository())
    }
    
    // MARK: Notification
    func makeNotificationViewModel() -> NotificationViewModel {
        return DefaultNotificationViewModel(
            loadNotificationsUseCase: makeLoadNotificationsUseCase(),
            updateNotificationIsAcceptedToTrueUseCase: makeUpdateNotificationIsAcceptedToTrueUseCase(),
            sendNotificationToParticipantUseCase: makeSendNotificationToParticipantUseCase(),
            updateGroupParticipantIDsToAddUseCase: makeUpdateGroupParticipantIDsToAddUseCase(),
            updateUserGroupsToAddGroupUseCase: makeUpdateUserGroupsToAddGroupUseCase(),
            deleteNotificationUseCase: makeDeleteNotificationUseCase()
        )
    }
}
