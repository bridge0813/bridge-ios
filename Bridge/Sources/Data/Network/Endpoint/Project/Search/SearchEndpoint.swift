//
//  SearchEndpoint.swift
//  Bridge
//
//  Created by 엄지호 on 2/6/24.
//

enum SearchEndpoint {
    case fetchRecentSearch
    case searchProjects(requestDTO: SearchProjectRequestDTO)
}

extension SearchEndpoint: Endpoint {
    var path: String {
        switch self {
        case .fetchRecentSearch:
            return "/searchWords"
            
        case .searchProjects:
            return "/projects/searchWord"
        }
    }
    
    var queryParameters: QueryParameters? {
        switch self {
        case .fetchRecentSearch:
            return nil
            
        case .searchProjects:
            return nil
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchRecentSearch:
            return .get
            
        case .searchProjects:
            return .post
        }
    }
    
    var body: Encodable? {
        switch self {
        case .fetchRecentSearch:
            return nil
            
        case .searchProjects(let requestDTO):
            return requestDTO
        }
    }
}
