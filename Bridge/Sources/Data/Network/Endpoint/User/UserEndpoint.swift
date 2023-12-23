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
    case fetchBookmarkedProjects(userID: String)
}

extension UserEndpoint: Endpoint {
    var path: String {
        switch self {
        case .fetchProfilePreview:
            return "/users/mypage"
            
        case .changeField:
            return "/users/field"
            
        case .fetchBookmarkedProjects:
            return "/users/bookmark"
        }
    }
    
    var queryParameters: QueryParameters? {
        switch self {
        case .fetchProfilePreview(let userID):
            return ["userId": userID]
            
        case .changeField:
            return nil
            
        case .fetchBookmarkedProjects(let userID):
            return ["userId": userID]
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchProfilePreview:
            return .get
            
        case .changeField:
            return .put
            
        case .fetchBookmarkedProjects:
            return .get
        }
    }
    
    var body: Encodable? {
        switch self {
        case .fetchProfilePreview:
            return nil
            
        case .changeField(let requestDTO):
            return requestDTO
            
        case .fetchBookmarkedProjects:
            return nil
        }
    }
}
