//
//  NetworkError.swift
//  Bridge
//
//  Created by 정호윤 on 2023/08/29.
//

import Foundation

enum NetworkError: Error {
    case invalidRequest
    case invalidResponse
    case statusCode(Int)
    case underlying(Error)
    case unknown
}

extension NetworkError: LocalizedError {
    var statusMessages: [Int: String] {
        [
            401: "로그인이 필요합니다."
        ]
    }

    var errorDescription: String? {
        switch self {
        case .invalidRequest:
            return "유효하지 않은 요청입니다."

        case .invalidResponse:
            return "유효하지 않은 응답입니다."

        case .statusCode(let statusCode):
            return statusMessages[statusCode] ?? "\(statusCode) 오류가 발생했습니다."

        case .underlying(let error):
            return error.localizedDescription

        case .unknown:
            return "알 수 없는 오류가 발생했습니다."
        }
    }
}
