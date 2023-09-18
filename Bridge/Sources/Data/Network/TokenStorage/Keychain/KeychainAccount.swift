//
//  KeychainAccount.swift
//  Bridge
//
//  Created by 정호윤 on 2023/09/18.
//

import Foundation

/// Keychain에서 사용할 계정 키를 나타내는 열거형
enum KeychainAccount: String, TokenKey {
    case userID = "com.bridge.userID"
    case refreshToken = "com.bridge.refreshToken"
}
