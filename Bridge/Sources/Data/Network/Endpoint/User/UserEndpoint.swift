//
//  UserEndpoint.swift
//  Bridge
//
//  Created by 엄지호 on 2023/11/25.
//  Edited by 정호윤 on 2023/12/12.

import Foundation

enum UserEndpoint {
    case fetchProfilePreview(userID: String)
    case changeField(requestDTO: ChangeFieldRequestDTO)
}

extension UserEndpoint: Endpoint {
    var path: String {
        switch self {
        case .fetchProfilePreview:
            return "/users/mypage"
            
        case .changeField:
            return "/users/field"
        }
    }
    
    var queryParameters: QueryParameters? {
        switch self {
        case .fetchProfilePreview(let userID):
            return ["userId": userID]
            
        case .changeField:
            return nil
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchProfilePreview:
            return .get
            
        case .changeField:
            return .put
        }
    }
    
    var body: Encodable? {
        switch self {
        case .fetchProfilePreview:
            return nil
            
        case .changeField(let requestDTO):
            return requestDTO
        }
    }
}
