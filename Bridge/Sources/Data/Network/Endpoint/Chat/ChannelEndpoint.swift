//
//  ChannelEndpoint.swift
//  Bridge
//
//  Created by 정호윤 on 10/11/23.
//

import Foundation

enum ChannelEndpoint {
    case channels(userID: String)
    case leaveChannel(id: String)
}

extension ChannelEndpoint: Endpoint {
    var path: String {
        switch self {
        case .channels(let userID):    
            return "/chat/\(userID)"
            
        case .leaveChannel:
            return "/chat"
        }
    }
    
    var queryParameters: QueryParameters? {
        switch self {
        case .channels:
            return nil
            
        case .leaveChannel(let id):
            return ["chatRoomId": id]
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .channels:        
            return .get
            
        case .leaveChannel:
            return .delete
        }
    }
    
    var body: Encodable? { nil }
}
