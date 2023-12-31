//
//  ProjectEndpoint.swift
//  Bridge
//
//  Created by 엄지호 on 2023/11/20.
//

enum ProjectEndpoint {
    case fetchAllProjects(userID: String)
    case fetchProjectsByField(requestDTO: FieldRequestDTO)
    case fetchHotProjects(userID: String)
    case fetchDeadlineProjects(userID: String)
    case fetchAppliedProjects
    case fetchMyProjects
    case fetchProjectDetail(userID: String, projectID: String)
    
    case create(requestDTO: CreateProjectRequestDTO)
    case delete(requestDTO: UserIDDTO, projectID: String)
    case bookmark(requestDTO: ProjectIDDTO)
    case close(requestDTO: ProjectIDDTO)
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
            
        case .fetchAppliedProjects:
            return "/projects/apply"
            
        case .fetchMyProjects:
            return "/projects"
            
        case .fetchProjectDetail:
            return "/project"
            
        case .create:
            return "/project"
            
        case .delete:
            return "/project"
            
        case .bookmark:
            return "/project/scrap"
            
        case .close:
            return "/project/deadline"
        }
    }
    
    var queryParameters: QueryParameters? {
        switch self {
        case .fetchAllProjects(let userID):
            return ["userId": userID]
            
        case .fetchProjectsByField:
            return nil
            
        case .fetchHotProjects(let userID):
            return ["userId": userID]
            
        case .fetchDeadlineProjects(let userID):
            return ["userId": userID]
            
        case .fetchAppliedProjects:
            return nil
            
        case .fetchMyProjects:
            return nil
            
        case .fetchProjectDetail(let userID, let projectID):
            return ["userId": userID, "projectId": projectID]
            
        case .create:
            return nil
            
        case .delete(_, let projectID):
            return ["projectId": projectID]
            
        case .bookmark:
            return nil
            
        case .close:
            return nil
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
            
        case .fetchAppliedProjects:
            return .get
            
        case .fetchMyProjects:
            return .get
            
        case .fetchProjectDetail:
            return .get
            
        case .create:
            return .post
            
        case .delete:
            return .delete
            
        case .bookmark:
            return .post
            
        case .close:
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
            
        case .fetchAppliedProjects:
            return nil
            
        case .fetchMyProjects:
            return nil
            
        case .fetchProjectDetail:
            return nil
            
        case .create(let requestDTO):
            return requestDTO
            
        case .delete(let requestDTO, _):
            return requestDTO
            
        case .bookmark(let requestDTO):
            return requestDTO
            
        case .close(let requestDTO):
            return requestDTO
        }
    }
}
