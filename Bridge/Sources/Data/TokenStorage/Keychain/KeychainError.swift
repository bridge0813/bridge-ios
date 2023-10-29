//
//  KeychainError.swift
//  Bridge
//
//  Created by 정호윤 on 2023/09/18.
//

/// 키체인 작업에서 발생할 수 있는 에러를 나타내는 열거형
enum KeychainError: Error {
    
    /// 키체인에서 데이터를 찾을 수 없을 때 발생하는 에러
    case noData
    
    /// 키체인에서 예상치 못한 데이터 형식을 반환했을 때 발생하는 에러
    case unexpectedData
    
    /// 처리되지 않은 에러.
    case unhandledError
    
    /// 에러에 대한 설명
    var description: String {
        switch self {
        case .noData:           return "No data was found in the keychain."
        case .unexpectedData:   return "The data found in the keychain was not as expected."
        case .unhandledError:   return "An unhandled error occurred."
        }
    }
}
