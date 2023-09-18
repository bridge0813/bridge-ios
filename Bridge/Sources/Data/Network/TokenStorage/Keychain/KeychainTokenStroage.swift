//
//  KeychainTokenStroage.swift
//  Bridge
//
//  Created by 정호윤 on 2023/09/18.
//

import Foundation
import RxSwift

/// 키체인을 이용해 토큰을 조회, 저장, 삭제하는 클래스
final class KeychainTokenStorage: TokenStorage {
    
    // MARK: - Fetch
    func fetchToken(for key: TokenKey) -> Single<Token?> {
        Single.create { single in
            let searchQuery: [CFString: Any] = [
                kSecClass: kSecClassGenericPassword,
                kSecAttrAccount: key.rawValue,
                kSecMatchLimit: kSecMatchLimitOne,
                kSecReturnAttributes: true,
                kSecReturnData: true
            ]
            
            var item: CFTypeRef?
            let status = SecItemCopyMatching(searchQuery as CFDictionary, &item)  // 일치하는 항목 있으면 item에 할당
            
            guard status == errSecSuccess else {
                single(.success(nil))
                return Disposables.create()
            }
            
            guard let existingItem = item as? [String: Any],
                  let data = existingItem[kSecValueData as String] as? Data,
                  let token = String(data: data, encoding: .utf8)
            else {
                single(.success(nil))
                return Disposables.create()
            }
            
            single(.success(token))
            return Disposables.create()
        }
    }
    
    // MARK: - Save
    func saveToken(_ token: Token, for key: TokenKey) -> Completable {
        Completable.create { [weak self] completable in
            guard let tokenData = token.data(using: .utf8) else {
                completable(.error(KeychainError.unexpectedData))
                return Disposables.create()
            }
            
            let saveQuery: [CFString: Any] = [
                kSecClass: kSecClassGenericPassword,
                kSecAttrAccount: key.rawValue,
                kSecValueData: tokenData
            ]
            
            let status = SecItemAdd(saveQuery as CFDictionary, nil)
            
            if status == errSecSuccess {
                completable(.completed)
            } else if status == errSecDuplicateItem {
                if let updateResult = self?.update(tokenData: tokenData, for: key) {
                    switch updateResult {
                    case .success:              completable(.completed)
                    case .failure(let error):   completable(.error(error))
                    }
                }
            } else {
                completable(.error(KeychainError.unhandledError))
            }
            
            return Disposables.create()
        }
    }
    
    // MARK: - Update
    private func update(tokenData: Data, for key: TokenKey) -> Result<Void, KeychainError> {
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
    func deleteToken(for key: TokenKey) -> Completable {
        return Completable.create { completable in
            let deleteQuery: [CFString: Any] = [
                kSecClass: kSecClassGenericPassword,
                kSecAttrAccount: key.rawValue
            ]
            
            let status = SecItemDelete(deleteQuery as CFDictionary)
            
            if status == errSecSuccess { completable(.completed) }
            else { completable(.error(KeychainError.unhandledError)) }
            
            return Disposables.create()
        }
    }
}
