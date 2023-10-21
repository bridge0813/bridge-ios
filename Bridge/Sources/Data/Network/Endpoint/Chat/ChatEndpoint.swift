//
//  ChatEndpoint.swift
//  Bridge
//
//  Created by 정호윤 on 10/11/23.
//

import Foundation

enum ChatEndpoint {
    case chatRooms(userID: String)
    case leaveChatRoom(chatRoomID: String)
}

extension ChatEndpoint: Endpoint {
    var path: String {
        switch self {
        case .chatRooms(let userID):    
            return "/chatRooms/\(userID)"
            
        case .leaveChatRoom(chatRoomID: let chatRoomID):
            return "/chatRooms/\(chatRoomID)"
        }
    }
    
    var queryParameters: QueryParameters? { nil }
    
    var method: HTTPMethod {
        switch self {
        case .chatRooms:        
            return .get
            
        case .leaveChatRoom:
            return .delete
        }
    }
    
    var body: Encodable? { nil }
}
