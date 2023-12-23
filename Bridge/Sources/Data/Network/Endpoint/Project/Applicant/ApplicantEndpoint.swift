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
    case cancel(projectID: String)
    case apply(projectID: String)
}

extension ApplicantEndpoint: Endpoint {
    var path: String {
        switch self {
        case .fetchApplicantList:
            return "/projects/apply/users"
            
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
            
        case .apply:
            return .post
            
        case .cancel:
            return .post
        }
    }
    
    var body: Encodable? { nil }
}
