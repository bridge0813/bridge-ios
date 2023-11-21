//
//  StompMessageDTO.swift
//  Bridge
//
//  Created by 정호윤 on 11/15/23.
//

import Foundation

/// STOMP로 메시지 요청 및 응답을 위한 타입
struct StompMessageDTO: Codable {
    let messageID = UUID().uuidString
    let channelID: String
    let senderID: String
    let type: String
    let content: String
    let hasRead = false
    let sentTime: String? = nil
    
    enum CodingKeys: String, CodingKey {
        case messageID = "messageId"
        case channelID = "chatRoomId"
        case senderID
        case type
        case content = "message"
        case hasRead = "readStat"
        case sentTime = "sendTime"
    }
    
    init(channelID: String, senderID: String, type: MessageResponseType, content: String) {
        self.channelID = channelID
        self.type = type.rawValue
        self.senderID = senderID
        self.content = content
    }
}

// MARK: - Custom type
extension StompMessageDTO {
    enum MessageResponseType: String {
        case talk = "TALK"
        case accept = "ACCEPT"
        case reject = "REJECT"
    }
}

// MARK: - Entity mapping
extension StompMessageDTO {
    func toEntity(userID: String) -> Message {
        Message(
            id: messageID,
            sender: userID == senderID ? .me : .opponent,
            type: mapToMessageType(type),
            sentDate: sentTime?.toDate() ?? "",
            sentTime: sentTime?.toSimpleTime() ?? "",
            hasRead: hasRead
        )
    }
    
    private func mapToMessageType(_ type: String) -> MessageType {
        switch type {
        case MessageResponseType.accept.rawValue:
            return .accept
            
        case MessageResponseType.reject.rawValue:
            return .reject
            
        default:
            return .text(content)
        }
    }
}

// MARK: - Encoding
extension StompMessageDTO {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(messageID, forKey: .messageID)
        try container.encode(channelID, forKey: .channelID)
        try container.encode(type, forKey: .type)
        try container.encode(senderID, forKey: .senderID)
        try container.encode(content, forKey: .content)
        try container.encode(hasRead, forKey: .hasRead)
        
        if let sentTime {
            try container.encode(sentTime, forKey: .sentTime)
        } else {
            try container.encodeNil(forKey: .sentTime)  // null 값 명시적으로 인코딩
        }
    }
}
