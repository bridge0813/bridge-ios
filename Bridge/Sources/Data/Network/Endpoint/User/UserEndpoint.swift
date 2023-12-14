//
//  UserEndpoint.swift
//  Bridge
//
//  Created by 엄지호 on 2023/11/25.
//  Edited by 정호윤 on 2023/12/12.

import Foundation

enum UserEndpoint {
    case fetchProfilePreview(userID: String)
}

extension UserEndpoint: Endpoint {
    var path: String {
        switch self {
        case .fetchProfilePreview:
            return "/users/mypage"
        }
    }
    
    var queryParameters: QueryParameters? {
        switch self {
        case .fetchProfilePreview(let userID):
            return ["userId": userID]
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
