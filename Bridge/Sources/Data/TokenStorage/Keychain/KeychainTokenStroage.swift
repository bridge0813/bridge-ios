//
//  KeychainTokenStroage.swift
//  Bridge
//
//  Created by 정호윤 on 2023/09/18.
//

import Foundation

struct KeychainTokenStorage: TokenStorage {
    // MARK: - Fetch
    func get(_ key: KeychainAccount) -> Token {
        let searchQuery: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key.rawValue,
            kSecMatchLimit: kSecMatchLimitOne,
            kSecReturnAttributes: true,
            kSecReturnData: true
        ]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(searchQuery as CFDictionary, &item)  // 일치하는 항목 있으면 item에 할당
        
        guard status == errSecSuccess else { return invalidToken }
        
        guard let existingItem = item as? [String: Any],
              let data = existingItem[kSecValueData as String] as? Data,
              let token = String(data: data, encoding: .utf8)
        else { return invalidToken }
        
        return token
    }
    
    // MARK: - Save
    func save(_ token: Token, for key: KeychainAccount) -> Bool {
        guard let tokenData = token.data(using: .utf8) else { return false }
        
        let saveQuery: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key.rawValue,
            kSecValueData: tokenData
        ]
        
        let status = SecItemAdd(saveQuery as CFDictionary, nil)
        
        if status == errSecSuccess {
            return true
        } else if status == errSecDuplicateItem {
            let updateResult = update(tokenData: tokenData, for: key)
            
            switch updateResult {
            case .success:  return true
            case .failure:  return false
            }
        } else {
            return false
        }
    }
    
    // MARK: - Update
    private func update(tokenData: Data, for key: KeychainAccount) -> Result<Void, KeychainError> {
        let searchQuery: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key.rawValue
        ]
        let updateQuery: [CFString: Any] = [kSecValueData: tokenData]
        
        let status = SecItemUpdate(searchQuery as CFDictionary, updateQuery as CFDictionary)
        
        if status == errSecSuccess { return .success(()) }
        else { return .failure(KeychainError.unhandledError) }
    }
    
    // MARK: - Delete
    func delete(_ key: KeychainAccount) -> Bool {
        let deleteQuery: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key.rawValue
        ]
        
        let status = SecItemDelete(deleteQuery as CFDictionary)
        
        return status == errSecSuccess
    }
}
