//
//  ChatGroupsRepository.swift
//  DevFriends
//
//  Created by 유승원 on 2022/11/18.
//
import FirebaseFirestore

protocol ChatGroupsRepository {
    func fetchFromLocal() -> [AcceptedGroup]
    func fetch(
        userID: String,
        messageListenersProcess: @escaping (_ messageListeners: [ListenerRegistration]) -> Void,
        groupProcess: @escaping (_ group: AcceptedGroup) -> Void
    ) -> ListenerRegistration
}
