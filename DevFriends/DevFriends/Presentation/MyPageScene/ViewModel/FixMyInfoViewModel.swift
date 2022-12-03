//
//  FixMyInfoViewModel.swift
//  DevFriends
//
//  Created by 상현 on 2022/11/29.
//

import Combine
import UIKit

struct FixMyInfoViewModelActions {
    let showCategoryChoice: () -> Void
    let popFixMyInfo: () -> Void
}

protocol FixMyInfoViewModelInput {
    func didLoadUser()
    func didTapDoneButton(nickname: String, job: String)
}

protocol FixMyInfoViewModelOutput {
    var profileImageSubject: CurrentValueSubject<UIImage?, Never> { get }
    var userNickName: String { get }
    var userJob: String { get }
}

protocol FixMyInfoViewModel: FixMyInfoViewModelInput, FixMyInfoViewModelOutput {}

final class DefaultFixMyInfoViewModel: FixMyInfoViewModel {
    private let actions: FixMyInfoViewModelActions
    private let updateUserInfoUseCase: UpdateUserInfoUseCase
    private let uploadProfileImageUseCase: UploadProfileImageUseCase
    private let fetchProfileImageUseCase: LoadProfileImageUseCase
    
    // MARK: - OUTPUT
    private let localUser: User
    var profileImageSubject = CurrentValueSubject<UIImage?, Never>(nil)
    var userNickName: String
    var userJob: String
    
    init(
        actions: FixMyInfoViewModelActions,
        updateUserInfoUseCase: UpdateUserInfoUseCase,
        uploadProfileImageUseCase: UploadProfileImageUseCase,
        fetchProfileImageUseCase: LoadProfileImageUseCase
    ) {
        self.actions = actions
        self.updateUserInfoUseCase = updateUserInfoUseCase
        self.uploadProfileImageUseCase = uploadProfileImageUseCase
        self.fetchProfileImageUseCase = fetchProfileImageUseCase
        
        localUser = User(
            id: "nqQW9nOes6UPXRCjBuCy",
            nickname: "흥민 손",
            job: "EPL득점왕",
            email: "abc@def.com",
            profileImagePath: "nqQW9nOes6UPXRCjBuCy",
            categoryIDs: [],
            appliedGroupIDs: [],
            likeGroupIDs: []
        )
        
        userNickName = localUser.nickname
        userJob = localUser.job
    }

    private func fetchImage() async -> UIImage? {
        var image: UIImage?
        if !localUser.profileImagePath.isEmpty {
            do {
                let data = try await fetchProfileImageUseCase.execute(path: localUser.profileImagePath)
                image = UIImage(data: data)
            } catch {
                print(error)
            }
        }
        
        return image
    }
    
    private func uploadImage() {
        guard let image = profileImageSubject.value else { return }
        
        guard
            let originData = image.jpegData(compressionQuality: 0.8),
            let thumbnailData = image.resize(newWidth: 100.0).jpegData(compressionQuality: 0.8) else { return }
        
        uploadProfileImageUseCase.execute(
            uid: localUser.id,
            originImage: originData,
            thumbnailImage: thumbnailData
        )
    }
    
    private func updateUser(nickname: String, job: String) {
        updateUserInfoUseCase.execute(
            profileImagePath: profileImageSubject.value == nil ? "" : self.localUser.id,
            nickName: nickname,
            job: job,
            user: self.localUser
        )
    }
}

extension DefaultFixMyInfoViewModel {
    func didLoadUser() {
        Task {
            profileImageSubject.value = await fetchImage()
        }
    }
    
    func didTapDoneButton(nickname: String, job: String) {
        uploadImage()
        updateUser(nickname: nickname, job: job)
        
        actions.popFixMyInfo()
    }
}
