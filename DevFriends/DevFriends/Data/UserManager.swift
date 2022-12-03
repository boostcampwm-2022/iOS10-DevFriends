//
//  UserManager.swift
//  DevFriends
//
//  Created by 유승원 on 2022/11/30.
//

import UIKit

enum UserInfoKey: String {
    case uid = "UID"
    case email = "EMAIL"
    case nickname = "NICKNAME"
    case job = "JOB"
    case profile = "PROFILE"
    case categoryIDs = "CATEGORYIDS"
    case appliedGroupIDs = "APPLIEDGROUPIDS"
    case isEnabledAutoLogin = "ISENABLEDAUTOLOGIN"
}

final class UserManager {
    static let shared = UserManager()
    
    // MARK: Computed Properties
    var uid: String? {
        get {
            return UserDefaults.standard.string(forKey: UserInfoKey.uid.rawValue)
        }
        
        set {
            let userDefaults = UserDefaults.standard
            userDefaults.set(newValue, forKey: UserInfoKey.uid.rawValue)
            userDefaults.synchronize()
        }
    }
    var email: String? {
        get {
            return UserDefaults.standard.string(forKey: UserInfoKey.email.rawValue)
        }
        
        set {
            let userDefaults = UserDefaults.standard
            userDefaults.set(newValue, forKey: UserInfoKey.email.rawValue)
            userDefaults.synchronize()
        }
    }
    var nickname: String? {
        get {
            return UserDefaults.standard.string(forKey: UserInfoKey.nickname.rawValue)
        }
        
        set {
            let userDefaults = UserDefaults.standard
            userDefaults.set(newValue, forKey: UserInfoKey.nickname.rawValue)
            userDefaults.synchronize()
        }
    }
    var job: String? {
        get {
            return UserDefaults.standard.string(forKey: UserInfoKey.job.rawValue)
        }
        
        set {
            let userDefaults = UserDefaults.standard
            userDefaults.set(newValue, forKey: UserInfoKey.job.rawValue)
            userDefaults.synchronize()
        }
    }
    var profile: UIImage? {
        get {
            if let profileData = UserDefaults.standard.data(forKey: UserInfoKey.profile.rawValue) {
                return UIImage(data: profileData)
            } else {
                return UIImage(named: "Image")
            }
        }
        
        set {
            let userDefaults = UserDefaults.standard
            userDefaults.set(newValue?.pngData(), forKey: UserInfoKey.profile.rawValue)
            userDefaults.synchronize()
        }
    }
    var categoryIDs: [String]? {
        get {
            return UserDefaults.standard.stringArray(forKey: UserInfoKey.categoryIDs.rawValue)
        }
        
        set {
            let userDefaults = UserDefaults.standard
            userDefaults.set(newValue, forKey: UserInfoKey.categoryIDs.rawValue)
            userDefaults.synchronize()
        }
    }
    var appliedGroupIDs: [String]? {
        get {
            return UserDefaults.standard.stringArray(forKey: UserInfoKey.appliedGroupIDs.rawValue)
        }
        
        set {
            let userDefaults = UserDefaults.standard
            userDefaults.set(newValue, forKey: UserInfoKey.appliedGroupIDs.rawValue)
            userDefaults.synchronize()
        }
    }
    var isEnabledAutoLogin: Bool {
        get {
            let isEnabled = UserDefaults.standard.bool(forKey: UserInfoKey.isEnabledAutoLogin.rawValue)
            if isEnabled, let uid = self.uid {
                self.login(uid: uid)
            }
            return isEnabled
        }
        
        set {
            let userDefaults = UserDefaults.standard
            userDefaults.set(newValue, forKey: UserInfoKey.isEnabledAutoLogin.rawValue)
            userDefaults.synchronize()
        }
    }
    
    private let userRepository = DefaultUserRepository()
    
    private init() {}
}

extension UserManager {
    func login(uid: String) {
        userRepository.fetch(uid: uid) { user in
            self.setUserInfo(of: user)
        }
    }
    
    func logout() {
        let userDefaults = UserDefaults.standard
        userDefaults.removeObject(forKey: UserInfoKey.uid.rawValue)
        userDefaults.removeObject(forKey: UserInfoKey.email.rawValue)
        userDefaults.removeObject(forKey: UserInfoKey.nickname.rawValue)
        userDefaults.removeObject(forKey: UserInfoKey.job.rawValue)
        userDefaults.removeObject(forKey: UserInfoKey.profile.rawValue)
        userDefaults.removeObject(forKey: UserInfoKey.categoryIDs.rawValue)
        userDefaults.removeObject(forKey: UserInfoKey.appliedGroupIDs.rawValue)
        userDefaults.removeObject(forKey: UserInfoKey.isEnabledAutoLogin.rawValue)
    }
    
    // MARK: Private
    private func setUserInfo(of user: User) {
        uid = user.id
        email = user.email
        nickname = user.nickname
        job = user.job
        categoryIDs = user.categoryIDs
        appliedGroupIDs = user.appliedGroupIDs
        
        Task {
            self.profile = await fetchProfile(path: user.profileImagePath)
        }
    }
    
    private func fetchProfile(path: String) async -> UIImage? {
        // TODO: 이후에 Firebase Storage에서 받아오는 코드 넣기
        return nil
    }
}

extension UserManager: CustomStringConvertible {
    var description: String {
        return """
uid: \(String(describing: self.uid))
email: \(String(describing: self.email))
nickname: \(String(describing: self.nickname))
job: \(String(describing: self.job))
categoryIDs: \(String(describing: self.categoryIDs))
appliedGroupIDs: \(String(describing: self.appliedGroupIDs))
"""
    }
}
