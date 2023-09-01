//
//  NetworkError.swift
//  Bridge
//
//  Created by 정호윤 on 2023/08/29.
//

enum NetworkError: Error {
    case invalidURL
    case unknown
}

extension NetworkError {
    var description: String? {
        switch self {
        case .invalidURL: return "올바르지 않은 URL입니다."
        case .unknown:    return "알 수 없는 오류입니다."
        }
    }
}
