//
//  ProjectEndpoint.swift
//  Bridge
//
//  Created by 엄지호 on 2023/11/20.
//

enum ProjectEndpoint {
    case fetchAllProjects
    case fetchProjectsByField(requestDTO: FieldRequestDTO)
    case fetchHotProjects
    case fetchDeadlineProjects
    case fetchProjectDetail(requestDTO: ProjectIDDTO, userID: String)
    
    case create(requestDTO: CreateProjectRequestDTO)
    case delete(requestDTO: UserIDDTO, projectID: String)
    case bookmark(requestDTO: ProjectIDDTO)
    case apply(userID: String, projectID: String)
}

extension ProjectEndpoint: Endpoint {
    var path: String {
        switch self {
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
            
        case .create:
            return "/project"
            
        case .delete:
            return "/project"
            
        case .bookmark:
            return "/project/scrap"
            
        case .apply:
            return "/project/apply"
        }
    }
    
    var queryParameters: QueryParameters? {
        switch self {
        case .fetchAllProjects:
            return nil
            
        case .fetchProjectsByField:
            return nil
            
        case .fetchHotProjects:
            return nil
            
        case .fetchDeadlineProjects:
            return nil
            
        case .fetchProjectDetail(_, let userID):
            return ["userId": userID]
            
        case .create:
            return nil
            
        case .delete(_, let projectID):
            return ["projectId": projectID]
            
        case .bookmark:
            return nil
            
        case .apply(let userID, let projectID):
            return ["userId": userID, "projectId": projectID]
        }
    }
    
    var method: HTTPMethod {
        switch self {
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
            
        case .create:
            return .post
            
        case .delete:
            return .delete
            
        case .bookmark:
            return .post
            
        case .apply:
            return .post
        }
    }
    
    var body: Encodable? {
        switch self {
        case .fetchAllProjects:
            return nil
            
        case .fetchProjectsByField(let requestDTO):
            return requestDTO
            
        case .fetchHotProjects:
            return nil
            
        case .fetchDeadlineProjects:
            return nil
            
        case .fetchProjectDetail(let requestDTO, _):
            return requestDTO
            
        case .create(let requestDTO):
            return requestDTO
            
        case .delete(let requestDTO, _):
            return requestDTO
            
        case .bookmark(let requestDTO):
            return requestDTO
            
        case .apply:
            return nil
        }
    }
}
