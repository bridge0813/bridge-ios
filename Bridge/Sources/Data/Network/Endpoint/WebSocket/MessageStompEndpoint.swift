//
//  MessageStompEndpoint.swift
//  Bridge
//
//  Created by 정호윤 on 11/15/23.
//

import Foundation

enum MessageStompEndpoint {
    case connect(destination: String)
    case disconnect
    
    case subscribe(destination: String)
    case unsubscribe(destination: String)
    
    case send(requestDTO: MessageRequestDTO)
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
        case .connect(let destination):
            return [
                StompHeaderKey.acceptVersion.rawValue: "1.1,1.2",
                StompHeaderKey.message.rawValue: destination
            ]
            
        case .disconnect:
            return nil
            
        // TODO: subscribe, unsubscribe id 헤더 수정 필요
        case .subscribe(let destination):
            return [
                StompHeaderKey.id.rawValue: destination,
                StompHeaderKey.destination.rawValue: "/sub/chat/room/\(destination)"
            ]
            
        case .unsubscribe(let destination):
            return [StompHeaderKey.id.rawValue: destination]
            
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
