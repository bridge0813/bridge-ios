//
//  MessageEndpoint.swift
//  Bridge
//
//  Created by 정호윤 on 11/13/23.
//

enum MessageEndpoint: Endpoint {
    case fetchMessages(channelID: String)
}

extension MessageEndpoint {
    var path: String {
        switch self {
        case .fetchMessages:
            return "/chat"
        }
    }
    
    var queryParameters: QueryParameters? {
        switch self {
        case .fetchMessages(let channelID):
            return ["chatRoomId": channelID]
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchMessages:
            return .get
        }
    }
    
    var body: Encodable? { nil }
}
