//
//  NetworkError.swift
//  Bridge
//
//  Created by 정호윤 on 2023/08/29.
//

enum NetworkError: Error {
    case invalidURL
    case statusCode(Int)
    case decodingFailed
    case unknown
}

extension NetworkError {
    var description: String? {
        switch self {
        case .invalidURL:
            return "올바르지 않은 URL입니다."
            
        case .statusCode(let statusCode):
            return "상태코드: \(statusCode)"
            
        case .decodingFailed:
            return "디코딩에 실패했습니다."
            
        case .unknown:
            return "알 수 없는 오류입니다."
        }
    }
}
