//
//  StompMessageRequestDTO.swift
//  Bridge
//
//  Created by 정호윤 on 12/6/23.
//

import Foundation

/// STOMP 메시지 전송을 위한 타입
struct StompMessageRequestDTO: Encodable {
    let messageID: String
    let channelID: String
    let senderID: Int
    let type: String
    let content: String
    var sentDateAndTime: String?
    let hasRead: Bool
    
    enum CodingKeys: String, CodingKey {
        case messageID = "messageId"
        case channelID = "chatRoomId"
        case senderID = "senderId"
        case type
        case content = "message"
        case sentDateAndTime = "sendTime"
        case hasRead = "readStat"
    }
    
    init(channelID: String, senderID: String, type: MessageRequestType, content: String) {
        self.messageID = UUID().uuidString
        self.channelID = channelID
        self.type = type.rawValue
        self.senderID = Int(senderID) ?? -1
        self.content = content
        self.hasRead = false
    }
}

// MARK: - Custom type
extension StompMessageRequestDTO {
    enum MessageRequestType: String {
        case talk = "TALK"
        case accept = "ACCEPT"
        case reject = "REJECT"
    }
}

// MARK: - Encoding
extension StompMessageRequestDTO {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(messageID, forKey: .messageID)
        try container.encode(channelID, forKey: .channelID)
        try container.encode(type, forKey: .type)
        try container.encode(senderID, forKey: .senderID)
        try container.encode(content, forKey: .content)
        try container.encode(hasRead, forKey: .hasRead)
        
        if let sentDateAndTime {
            try container.encode(sentDateAndTime, forKey: .sentDateAndTime)
        } else {
            try container.encodeNil(forKey: .sentDateAndTime)  // null 값 명시적으로 인코딩
        }
    }
}
