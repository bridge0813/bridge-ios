//
//  WebSocketEndpoint.swift
//  Bridge
//
//  Created by 정호윤 on 10/18/23.
//

import Foundation

enum WebSocketEndpoint {
    case connect
}

extension WebSocketEndpoint: Endpoint {
    var baseURL: URL? {
        URL(string: "http://54.180.195.17:8080")
    }
    
    var path: String {
        switch self {
        case .connect:  
            return "/ws"
        }
    }
    
    var headers: HTTPHeaders {
        [:]
    }
    
    var queryParameters: QueryParameters? {
        nil
    }
    
    var method: HTTPMethod {
        switch self {
        case .connect:
            return .get
        }
    }
    
    var body: Encodable? {
        nil
    }
}
