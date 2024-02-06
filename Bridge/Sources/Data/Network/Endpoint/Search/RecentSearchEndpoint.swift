//
//  RecentSearchEndpoint.swift
//  Bridge
//
//  Created by 엄지호 on 2/6/24.
//

enum RecentSearchEndpoint {
    case fetchRecentSearch
}

extension RecentSearchEndpoint: Endpoint {
    var path: String {
        switch self {
        case .fetchRecentSearch:
            return "/searchWords"
        }
    }
    
    var queryParameters: QueryParameters? {
        switch self {
        case .fetchRecentSearch:
            return nil
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchRecentSearch:
            return .get
        }
    }
    
    var body: Encodable? {
        switch self {
        case .fetchRecentSearch:
            return nil
        }
    }
}
