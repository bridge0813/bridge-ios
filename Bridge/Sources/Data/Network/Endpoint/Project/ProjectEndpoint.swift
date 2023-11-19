//
//  ProjectEndpoint.swift
//  Bridge
//
//  Created by 엄지호 on 2023/11/20.
//

enum ProjectEndpoint {
    case create(requestDTO: CreateProjectDTO)
}

extension ProjectEndpoint: Endpoint {
    var path: String {
        switch self {
        case .create:
            return "/project"
        }
    }
    
    var queryParameters: QueryParameters? {
        switch self {
        case .create:
            return nil
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .create:
            return .post
        }
    }
    
    var body: Encodable? {
        switch self {
        case .create(let requestDTO):  return requestDTO
        }
    }
}
