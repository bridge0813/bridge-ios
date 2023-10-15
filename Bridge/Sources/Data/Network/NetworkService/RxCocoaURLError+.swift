//
//  RxCocoaURLError+.swift
//  Bridge
//
//  Created by 정호윤 on 10/15/23.
//

import RxCocoa

extension RxCocoaURLError {
    func toNetworkError() -> NetworkError {
        switch self {
        case .unknown, .deserializationError:
            return NetworkError.unknown
            
        case .nonHTTPResponse:
            return NetworkError.invalidResponse
            
        case .httpRequestFailed(let response, _):
            return NetworkError.statusCode(response.statusCode)
        }
    }
}
