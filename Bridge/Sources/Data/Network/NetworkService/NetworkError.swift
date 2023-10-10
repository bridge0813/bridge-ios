//
//  NetworkError.swift
//  Bridge
//
//  Created by 정호윤 on 2023/08/29.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    
    /// 기대하지 않은 응답 타입일 때 (e.g. HTTPURLResponse가 아닐 때)
    case invalidResponseType
    
    case decodingFailed
    
    case statusCode(Int)
    
    case underlying(Error)
    
    case unknown
}

extension NetworkError: LocalizedError {
    static let statusMessages = [
        401: "Unauthorized",
    ]
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "invalid URL"
            
        case .invalidResponseType:
            return "received invalid response type"
            
        case .decodingFailed:
            return "failed to decode response"
            
        case .statusCode(let statusCode):
            return NetworkError.statusMessages[statusCode] ?? "undeclared status code: \(statusCode) error"
            
        case .underlying(let error):
            return error.localizedDescription
            
        case .unknown:
            return "unknown error occured"
        }
    }
}
