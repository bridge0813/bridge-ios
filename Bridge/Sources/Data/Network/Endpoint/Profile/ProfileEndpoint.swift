//
//  ProfileEndpoint.swift
//  Bridge
//
//  Created by 엄지호 on 2023/11/25.
//

import Foundation

enum ProfileEndpoint {
    case fetchProfilePreview(userId: String)
}

extension ProfileEndpoint: Endpoint {
    var path: String {
        switch self {
        case .fetchProfilePreview:
            return "/users/mypage"
        }
    }
    
    var queryParameters: QueryParameters? {
        switch self {
        case .fetchProfilePreview(let userId):
            return ["userId": userId]
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchProfilePreview:
            return .get
        }
    }
    
    var body: Encodable? { nil }
}
