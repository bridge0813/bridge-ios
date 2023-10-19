//
//  KeychainAccount.swift
//  Bridge
//
//  Created by 정호윤 on 2023/09/18.
//

import Foundation

/// Keychain에서 사용할 계정 키를 나타내는 열거형
enum KeychainAccount: String {
    case userName = "com.bridge.userName"
    case userID = "com.bridge.userID"
    case accessToken = "com.bridge.accessToken"
    case refreshToken = "com.bridge.refreshToken"
}
