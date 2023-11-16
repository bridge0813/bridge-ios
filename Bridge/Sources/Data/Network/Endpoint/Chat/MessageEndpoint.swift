//
//  MessageEndpoint.swift
//  Bridge
//
//  Created by 정호윤 on 11/13/23.
//

enum MessageEndpoint: Endpoint {
    case messages(channelID: String)
}

extension MessageEndpoint {
    var path: String {
        switch self {
        case .messages:
            return "/chat"
        }
    }
    
    var queryParameters: QueryParameters? {
        switch self {
        case .messages(let channelID):
            return ["chatRoomId": channelID]
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .messages:
            return .get
        }
    }
    
    var body: Encodable? { nil }
}
