//
//  ChannelEndpoint.swift
//  Bridge
//
//  Created by 정호윤 on 10/11/23.
//

enum ChannelEndpoint {
    case fetchChannels(userID: String)
    case leaveChannel(id: String)
}

extension ChannelEndpoint: Endpoint {
    var path: String {
        switch self {
        case .fetchChannels(let userID):    
            return "/chat/\(userID)"
            
        case .leaveChannel:
            return "/chat"
        }
    }
    
    var queryParameters: QueryParameters? {
        switch self {
        case .fetchChannels:
            return nil
            
        case .leaveChannel(let id):
            return ["chatRoomId": id]
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchChannels:        
            return .get
            
        case .leaveChannel:
            return .delete
        }
    }
    
    var body: Encodable? { nil }
}
