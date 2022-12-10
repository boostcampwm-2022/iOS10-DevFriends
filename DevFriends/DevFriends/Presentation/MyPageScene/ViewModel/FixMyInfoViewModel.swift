//
//  FixMyInfoViewModel.swift
//  DevFriends
//
//  Created by 상현 on 2022/11/29.
//

import Combine
import UIKit

struct FixMyInfoViewModelActions {
    let showCategoryChoice: ([Category]?) -> Void
    let didSubmitFixInfo: (String, UIImage?, [Category]) -> Void
    let popFixMyInfo: () -> Void
}

protocol FixMyInfoViewModelInput {
    func didCategorySelectionView(categories: [Category]?)
    func didTapDoneButton(nickname: String, job: String)
    func didTouchedBackButton()
}

protocol FixMyInfoViewModelOutput {
    var profileImageSubject: CurrentValueSubject<UIImage?, Never> { get }
    var categoriesSubject: CurrentValueSubject<[Category], Never> { get }
    var userNickName: String { get }
    var userJob: String { get }
}

protocol FixMyInfoViewModel: FixMyInfoViewModelInput, FixMyInfoViewModelOutput {}

final class DefaultFixMyInfoViewModel: FixMyInfoViewModel {
    private let actions: FixMyInfoViewModelActions
    private let updateUserInfoUseCase: UpdateUserInfoUseCase
    private let uploadProfileImageUseCase: UploadProfileImageUseCase
    private let fetchProfileImageUseCase: LoadProfileImageUseCase
    private let loadCategoryUseCase: LoadCategoryUseCase
    
    // MARK: - OUTPUT
    private var userInfo: FixMyInfoStruct
    var profileImageSubject = CurrentValueSubject<UIImage?, Never>(nil)
    var categoriesSubject = CurrentValueSubject<[Category], Never>([])
    var userNickName: String
    var userJob: String
    
    init(
        userInfo: FixMyInfoStruct,
        actions: FixMyInfoViewModelActions,
        updateUserInfoUseCase: UpdateUserInfoUseCase,
        uploadProfileImageUseCase: UploadProfileImageUseCase,
        fetchProfileImageUseCase: LoadProfileImageUseCase,
        loadCategoryUseCase: LoadCategoryUseCase
    ) {
        self.userInfo = userInfo
        self.actions = actions
        self.updateUserInfoUseCase = updateUserInfoUseCase
        self.uploadProfileImageUseCase = uploadProfileImageUseCase
        self.fetchProfileImageUseCase = fetchProfileImageUseCase
        self.loadCategoryUseCase = loadCategoryUseCase
        
        profileImageSubject.value = userInfo.image
        categoriesSubject.value = userInfo.categories
        userNickName = userInfo.user.nickname
        userJob = userInfo.user.job
    }
    
    private func uploadImage() {
        guard let image = profileImageSubject.value else { return }
        
        guard
            let originData = image.jpegData(compressionQuality: 0.8),
            let thumbnailData = image.resize(newWidth: 100.0).jpegData(compressionQuality: 0.8) else { return }
        
        let path: String
        if userInfo.user.profileImagePath.isEmpty {
            userInfo.user.profileImagePath = userInfo.user.id + "0"
        } else {
            let lastChar = userInfo.user.profileImagePath.removeLast()
            
            if lastChar == "0" {
                userInfo.user.profileImagePath += "1"
            } else {
                userInfo.user.profileImagePath += "0"
            }
        }
        path = userInfo.user.profileImagePath
        
        uploadProfileImageUseCase.execute(
            path: userInfo.user.id,
            originImage: originData,
            thumbnailImage: thumbnailData
        )
    }
    
    private func updateUser(nickname: String, job: String, categoryIDs: [String]) {
        updateUserInfoUseCase.execute(
            profileImagePath: profileImageSubject.value == nil ? "" : userInfo.user.profileImagePath,
            nickName: nickname,
            job: job,
            user: userInfo.user,
            categoryIDs: categoryIDs
        )
    }
}

extension DefaultFixMyInfoViewModel {
    func didCategorySelectionView(categories: [Category]?) {
        actions.showCategoryChoice(categories)
    }
    
    func didTapDoneButton(nickname: String, job: String) {
        uploadImage()
        updateUser(nickname: nickname, job: job, categoryIDs: categoriesSubject.value.map { $0.id })
        
        actions.didSubmitFixInfo(nickname, profileImageSubject.value, categoriesSubject.value)
    }
    
    func didTouchedBackButton() {
        actions.popFixMyInfo()
    }
}
