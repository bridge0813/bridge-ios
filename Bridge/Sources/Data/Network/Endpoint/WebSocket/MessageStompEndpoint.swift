//
//  MessageStompEndpoint.swift
//  Bridge
//
//  Created by 정호윤 on 11/15/23.
//

import Foundation

enum MessageStompEndpoint {
    case connect
    case disconnect
    
    case subscribe(destination: String, userID: String)
    case unsubscribe(destination: String, userID: String)
    
    case send(requestDTO: StompMessageRequestDTO)
}

extension MessageStompEndpoint: StompEndpoint {
    var command: StompRequestCommand {
        switch self {
        case .connect:
            return .connect
            
        case .disconnect:
            return .disconnect
            
        case .subscribe:
            return .subscribe
            
        case .unsubscribe:
            return .unsubscribe
            
        case .send:
            return .send
        }
        
    }
    
    var headers: StompHeaders? {
        switch self {
        case .connect:
            return [StompHeaderKey.acceptVersion.rawValue: "1.1,1.2"]
            
        case .disconnect:
            return nil
            
        case .subscribe(let destination, let userID):
            return [
                StompHeaderKey.id.rawValue: userID,
                StompHeaderKey.destination.rawValue: "/sub/chat/room/\(destination)",
                StompHeaderKey.message.rawValue: "\(destination)/\(userID)"
            ]
            
        case .unsubscribe(let destination, let userID):
            return [
                StompHeaderKey.message.rawValue: destination,
                StompHeaderKey.id.rawValue: userID
            ]
            
        case .send:
            return [StompHeaderKey.destination.rawValue: "/pub/chat/message"]
        }
    }
    
    var body: Encodable? {
        switch self {
        case .connect, .disconnect, .subscribe, .unsubscribe:
            return nil
            
        case .send(let messageRequestDTO):
            return messageRequestDTO
        }
    }
}
