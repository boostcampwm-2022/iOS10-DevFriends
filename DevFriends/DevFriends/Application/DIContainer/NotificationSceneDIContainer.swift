//
//  NotificationSceneDIContainer.swift
//  DevFriends
//
//  Created by 유승원 on 2022/11/22.
//

import UIKit

struct NotificationSceneDIContainer {
    // MARK: Flow Coordinators
    func makeNotificationCoordinator(navigationController: UINavigationController) -> NotificationCoordinator {
        return NotificationCoordinator(navigationController: navigationController, dependencies: self)
    }
}

extension NotificationSceneDIContainer: NotificationCoordinatorDependencies {
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
    func makeNotificationViewModel(actions: NotificationViewModelActions) -> NotificationViewModel {
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
