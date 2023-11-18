//
//  StompMessageDTO.swift
//  Bridge
//
//  Created by 정호윤 on 11/15/23.
//

import Foundation

struct StompMessageDTO: Codable {
    let messageID: String
    let channelID: String
    let type: String
    let sender: String
    let content: String
    let hasRead: Bool
    let sendTime: String?
    
    enum CodingKeys: String, CodingKey {
        case messageID = "messageId"
        case channelID = "chatRoomId"
        case type
        case sender
        case content = "message"
        case hasRead = "readStat"
        case sendTime
    }
    
    init(channelID: String, type: MessageType, sender: String, content: String) {
        self.messageID = UUID().uuidString
        self.channelID = channelID
        self.type = type.rawValue
        self.sender = sender
        self.content = content
        self.hasRead = false
        self.sendTime = nil
    }
}

// MARK: - Custom type
extension StompMessageDTO {
    enum MessageType: String {
        case talk = "TALK"
        case accept = "ACCEPT"
        case reject = "REJECT"
    }
}

// MARK: - Entity mapping
extension StompMessageDTO {
    func toEntity() -> Message {
        Message(
            id: messageID,
            sender: sender == self.sender ? .me : .opponent,
            type: .text(content),
            sentDate: sendTime?.toDate() ?? "",
            sentTime: sendTime?.toSimpleTime() ?? "",
            hasRead: hasRead
        )
    }
}

// MARK: - Encoding
extension StompMessageDTO {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(messageID, forKey: .messageID)
        try container.encode(channelID, forKey: .channelID)
        try container.encode(type, forKey: .type)
        try container.encode(sender, forKey: .sender)
        try container.encode(content, forKey: .content)
        try container.encode(hasRead, forKey: .hasRead)
        
        if let sendTime {
            try container.encode(sendTime, forKey: .sendTime)
        } else {
            try container.encodeNil(forKey: .sendTime)  // null 값 명시적으로 인코딩
        }
    }
}
