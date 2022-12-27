//
//  MyInfoRepository.swift
//  DevFriends
//
//  Created by 유승원 on 2022/12/27.
//

import UIKit

protocol MyInfoRepository {
    var user: User { get }
    var uid: String? { get set }
    var email: String? { get set }
    var nickname: String? { get set }
    var job: String? { get set }
    var profileImagePath: String? { get set }
    var profile: UIImage? { get set }
    var categoryIDs: [String]? { get set }
    var joinedGroupIDs: [String]? { get set }
    var appliedGroupIDs: [String]? { get set }
    var likeGroupIDs: [String]? { get set }
    var isEnabledAutoLogin: Bool { get set }
    
    func login(uid: String)
    func logout()
}
