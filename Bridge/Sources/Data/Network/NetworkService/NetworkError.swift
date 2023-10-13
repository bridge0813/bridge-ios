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
    case unauthorized
    case statusCode(Int)
    case underlying(Error)
    case unknown
}

//extension NetworkError: LocalizedError {
//    static let statusMessages = [
//        401: "Unauthorized"
//    ]
//
//    var errorDescription: String? {
//        switch self {
//        case .invalidRequest:
//            return "invalid URLRequest"
//
//        case .invalidResponse:
//            return "received invalid response type"
//
//        case .unauthorized:
//            return "unauthorized user"
//
//        case .decodingFailed:
//            return "failed to decode response"
//
//        case .statusCode(let statusCode):
//            return NetworkError.statusMessages[statusCode] ?? "undeclared status code: \(statusCode) error"
//
//        case .underlying(let error):
//            return error.localizedDescription
//
//        case .unknown:
//            return "unknown error occured"
//        }
//    }
//}
