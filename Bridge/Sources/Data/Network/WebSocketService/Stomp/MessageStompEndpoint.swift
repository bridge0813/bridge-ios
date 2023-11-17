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
    case subscribe(destination: String)
    case unsubscribe(destination: String)
    case sendMessage(requestDTO: MessageRequestDTO)
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
            
        case .sendMessage:
            return .send
        }
        
    }
    
    var headers: StompHeaders? {
        switch self {
        case .connect:
            return [StompHeaderKey.acceptVersion.rawValue: "1.1,1.2"]
            
        case .disconnect:
            return nil
            
        case .subscribe(let destination):
            return [
                StompHeaderKey.id.rawValue: UUID().uuidString,
                StompHeaderKey.destination.rawValue: "/sub/chat/room/\(destination)"
            ]
            
        case .unsubscribe(let destination):
            return [StompHeaderKey.id.rawValue: destination]
            
        case .sendMessage:
            return [StompHeaderKey.destination.rawValue: "/pub/chat/message"]
        }
    }
    
    var body: Encodable? {
        switch self {
        case .connect, .disconnect, .subscribe, .unsubscribe:
            return nil
            
        case .sendMessage(let messageRequestDTO):
            return messageRequestDTO
        }
    }
}
