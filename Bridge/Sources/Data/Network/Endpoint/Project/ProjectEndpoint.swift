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
    case fetchProjectDetail(requestDTO: ProjectIDDTO, userID: String)
    
    case bookmark(requestDTO: ProjectIDDTO)
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
            
        case .fetchProjectDetail:
            return "/project"
            
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
            
        case .fetchProjectDetail(_, userID: let userID):
            return ["userId": userID]
            
        case .bookmark:
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
            
        case .fetchDeadlineProjects:
            return .get
            
        case .fetchProjectDetail:
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
            
        case .fetchProjectDetail(requestDTO: let projectID, _):
            return projectID
            
        case .bookmark(requestDTO: let projectID):
            return projectID
        }
    }
}
