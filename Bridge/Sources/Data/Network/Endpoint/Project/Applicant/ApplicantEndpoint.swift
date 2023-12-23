//
//  ApplicantEndpoint.swift
//  Bridge
//
//  Created by 엄지호 on 12/23/23.
//

import Foundation

/// 모집글의 지원자 수락, 거절, 리스트 등 지원자에 관한 작업
enum ApplicantEndpoint {
    case fetchApplicantList(projectID: String)
    case accept(userID: String, projectID: String)
    case reject(userID: String, projectID: String)
    case apply(projectID: String)
    case cancel(projectID: String)
}

extension ApplicantEndpoint: Endpoint {
    var path: String {
        switch self {
        case .fetchApplicantList:
            return "/projects/apply/users"
            
        case .accept:
            return "/projects/accept"
           
        case .reject:
            return "/projects/reject"
            
        case .apply:
            return "/projects/apply"
            
        case .cancel:
            return "/projects/apply/cancel"
        }
    }
    
    var queryParameters: QueryParameters? {
        switch self {
        case .fetchApplicantList(let projectID):
            return ["projectId": projectID]
            
        case .accept(let userID, let projectID):
            return ["userId": userID, "projectId": projectID]
            
        case .reject(let userID, let projectID):
            return ["userId": userID, "projectId": projectID]
            
        case .apply(let projectID):
            return ["projectId": projectID]
            
        case .cancel(let projectID):
            return ["projectId": projectID]
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchApplicantList:
            return .get
            
        case .accept:
            return .put
            
        case .reject:
            return .put
            
        case .apply:
            return .post
            
        case .cancel:
            return .post
        }
    }
    
    var body: Encodable? { nil }
}
