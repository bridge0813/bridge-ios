//
//  TokenStorage.swift
//  Bridge
//
//  Created by 정호윤 on 2023/09/18.
//

typealias Token = String
let invalidToken = "-1"

/// 토큰 저장소
protocol TokenStorage {
    /// 저장소에서 주어진 키에 대한 토큰을 가져옵니다.
    /// - Parameter key: 토큰을 가져올 키입니다.
    /// - Returns: 토큰이 존재하는 경우 토큰을, 그렇지 않으면 `nil`을 반환합니다.
    func get(_ key: KeychainAccount) -> Token?
    
    /// 주어진 키에 대한 토큰이 존재하지 않는다면 저장소에 저장하고, 존재한다면 업데이트 합니다.
    /// - Parameters:
    ///   - token: 저장할 토큰입니다.
    ///   - key: 토큰을 저장할 키입니다.
    /// - Returns: 저장 작업이 성공했는지를 나타내는 `Bool`입니다.
    @discardableResult
    func save(_ token: Token, for key: KeychainAccount) -> Bool
    
    /// 저장소에서 주어진 키의 토큰을 삭제합니다.
    /// - Parameter key: 토큰을 삭제할 키입니다.
    /// - Returns: 삭제 작업이 성공했는지를 나타내는 `Bool`입니다.
    @discardableResult
    func delete(_ key: KeychainAccount) -> Bool
}
