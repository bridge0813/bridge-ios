//
//  ProjectEndpoint.swift
//  Bridge
//
//  Created by 엄지호 on 2023/11/20.
//

enum ProjectEndpoint {
    case create(requestDTO: CreateProjectRequestDTO)
    
    case fetchAllProjects
    case fetchProjectsByField(requestDTO: FieldRequestDTO)
    case fetchHotProjects
    case fetchDeadlineProjects
    
    case bookmark(requestDTO: BookmarkRequestDTO, userID: String)
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
            
        case .fetchDeadlineProjects:
            return "/projects/imminent"
            
        case .bookmark:
            return "/project/scrap"
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
            
        case .fetchDeadlineProjects:
            return nil
            
        case .bookmark(_, userID: let userID):
            return ["userId": userID]
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
            
        case .fetchDeadlineProjects:
            return .get
            
        case .bookmark:
            return .post
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
            
        case .fetchDeadlineProjects:
            return nil
            
        case .bookmark(requestDTO: let projectID, _):
            return projectID
        }
    }
}
