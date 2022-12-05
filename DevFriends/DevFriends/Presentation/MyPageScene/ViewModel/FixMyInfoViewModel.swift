//
//  FixMyInfoViewModel.swift
//  DevFriends
//
//  Created by 상현 on 2022/11/29.
//

import Combine
import UIKit

struct FixMyInfoViewModelActions {
    let showCategoryChoice: ([Category]) -> Void
    let popFixMyInfo: () -> Void
}

protocol FixMyInfoViewModelInput {
    func didLoadUser()
    func didCategorySelectionView(categories: [Category])
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
    private let localUser: User
    var profileImageSubject = CurrentValueSubject<UIImage?, Never>(nil)
    var categoriesSubject = CurrentValueSubject<[Category], Never>([])
    var userNickName: String
    var userJob: String
    
    init(
        actions: FixMyInfoViewModelActions,
        updateUserInfoUseCase: UpdateUserInfoUseCase,
        uploadProfileImageUseCase: UploadProfileImageUseCase,
        fetchProfileImageUseCase: LoadProfileImageUseCase,
        loadCategoryUseCase: LoadCategoryUseCase
    ) {
        self.actions = actions
        self.updateUserInfoUseCase = updateUserInfoUseCase
        self.uploadProfileImageUseCase = uploadProfileImageUseCase
        self.fetchProfileImageUseCase = fetchProfileImageUseCase
        self.loadCategoryUseCase = loadCategoryUseCase
        
        localUser = User(
            id: "nqQW9nOes6UPXRCjBuCy",
            nickname: "흥민 손",
            job: "EPL득점왕",
            email: "abc@def.com",
            profileImagePath: "nqQW9nOes6UPXRCjBuCy",
            categoryIDs: ["89kKYamuTTGC0rK7VZO8", "spXVLStPa1WBZVQlebCi"],
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
    
    private func loadCategories(categoryIds: [String]) async -> [Category] {
        var categories: [Category] = []
        if !categoryIds.isEmpty {
            do {
                categories = try await loadCategoryUseCase.execute(categoryIds: categoryIds)
            } catch {
                print(error)
            }
        }
        
        return categories
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
    
    private func updateUser(nickname: String, job: String, categoryIDs: [String]) {
        updateUserInfoUseCase.execute(
            profileImagePath: profileImageSubject.value == nil ? "" : self.localUser.id,
            nickName: nickname,
            job: job,
            user: self.localUser,
            categoryIDs: categoryIDs
        )
    }
}

extension DefaultFixMyInfoViewModel {
    func didLoadUser() {
        Task {
            profileImageSubject.value = await fetchImage()
            categoriesSubject.value = await loadCategories(categoryIds: localUser.categoryIDs)
        }
    }
    
    func didCategorySelectionView(categories: [Category]) {
        actions.showCategoryChoice(categories)
    }
    
    func didTapDoneButton(nickname: String, job: String) {
        uploadImage()
        updateUser(nickname: nickname, job: job, categoryIDs: categoriesSubject.value.map { $0.id })
        
        actions.popFixMyInfo()
    }
    
    func didTouchedBackButton() {
        actions.popFixMyInfo()
    }
}
