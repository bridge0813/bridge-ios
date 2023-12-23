//
//  ChannelEndpoint.swift
//  Bridge
//
//  Created by 정호윤 on 10/11/23.
//

enum ChannelEndpoint {
    case fetchChannels(userID: String)
    case leaveChannel(id: String)
    case createChannel(requestDTO: CreateChannelRequestDTO)
}

extension ChannelEndpoint: Endpoint {
    var path: String {
        switch self {
        case .fetchChannels(let userID):    
            return "/chat/\(userID)"
            
        case .leaveChannel:
            return "/chat"
            
        case .createChannel:
            return "/chat"
        }
    }
    
    var queryParameters: QueryParameters? {
        switch self {
        case .fetchChannels:
            return nil
            
        case .leaveChannel(let id):
            return ["chatRoomId": id]
            
        case .createChannel:
            return nil
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchChannels:        
            return .get
            
        case .leaveChannel:
            return .delete
            
        case .createChannel:
            return .post
        }
    }
    
    var body: Encodable? {
        switch self {
        case .fetchChannels:
            return nil
            
        case .leaveChannel:
            return nil
            
        case .createChannel(let requestDTO):
            return requestDTO
        }
    }
}
