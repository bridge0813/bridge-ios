//
//  MessageStompEndpoint.swift
//  Bridge
//
//  Created by 정호윤 on 11/15/23.
//

import Foundation

enum MessageStompEndpoint {
    case connect
    case subscribe(destination: String)
    case sendMessage(requestDTO: MessageRequestDTO)
}

extension MessageStompEndpoint: StompEndpoint {
    var command: StompRequestCommand {
        switch self {
        case .connect:      
            return .connect
            
        case .subscribe:    
            return .subscribe
            
        case .sendMessage:         
            return .send
        }
    }
    
    var headers: StompHeaders? {
        switch self {
        case .connect:
            return [StompHeaderKey.acceptVersion.rawValue: "1.1,1.2"]
            
        case .subscribe(let destination):
            return [
                StompHeaderKey.id.rawValue: destination,
                StompHeaderKey.destination.rawValue: "/sub/chat/room/\(destination)"
            ]
            
        case .sendMessage:
            return [
                StompHeaderKey.destination.rawValue: "/pub/chat/message",
                StompHeaderKey.contentType.rawValue: "application/json"
            ]
        }
    }
    
    var body: Encodable? {
        switch self {
        case .connect:
            return nil
            
        case .subscribe:
            return nil
            
        case .sendMessage(let messageRequestDTO):
            return messageRequestDTO
        }
    }
}
