//
//  ProjectEndpoint.swift
//  Bridge
//
//  Created by 엄지호 on 2023/11/20.
//

enum ProjectEndpoint {
    case create(requestDTO: CreateProjectRequestDTO)
    
    // TODO: - 통합처리 생각해보기
    case fetchAllProjects
    case fetchProjectsByField(requestDTO: FieldRequestDTO)
    case fetchHotProjects
}

extension ProjectEndpoint: Endpoint {
    var path: String {
        switch self {
        case .create:
            return "/project"
            
        case .fetchAllProjects:
            return "/projects/all"
            
        case .fetchProjectsByField:
            return "/projects/mypart"
            
        case .fetchHotProjects:
            return "/projects/top"
        }
    }
    
    var queryParameters: QueryParameters? {
        switch self {
        case .create:
            return nil
            
        case .fetchAllProjects:
            return nil
            
        case .fetchProjectsByField:
            return nil
            
        case .fetchHotProjects:
            return nil
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .create:
            return .post
            
        case .fetchAllProjects:
            return .get
            
        case .fetchProjectsByField:
            return .post
            
        case .fetchHotProjects:
            return .get
        }
    }
    
    var body: Encodable? {
        switch self {
        case .create(let requestDTO):
            return requestDTO
            
        case .fetchAllProjects:
            return nil
            
        case .fetchProjectsByField(let field):
            return field
            
        case .fetchHotProjects:
            return nil
        }
    }
}
