//
//  ProfileEndpoint.swift
//  Bridge
//
//  Created by 엄지호 on 2023/11/25.
//

import Foundation

enum ProfileEndpoint {
    case profilePreview(userId: String)
}

extension ProfileEndpoint: Endpoint {
    var path: String {
        switch self {
        case .profilePreview:
            return "/users/mypage"
        }
    }
    
    var queryParameters: QueryParameters? {
        switch self {
        case .profilePreview(let userId):
            return ["userId": userId]
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .profilePreview:
            return .get
        }
    }
    
    var body: Encodable? { nil }
}
