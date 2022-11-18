//
//  ChatContentViewModel.swift
//  DevFriends
//
//  Created by 유승원 on 2022/11/18.
//

import Foundation

struct ChatContentViewModelActions {}

protocol ChatContentViewModelInput {}
protocol ChatContentViewModelOutput {}

protocol ChatContentViewModel: ChatContentViewModelInput, ChatContentViewModelOutput {}

final class DefaultChatContentViewModel: ChatContentViewModel {}
