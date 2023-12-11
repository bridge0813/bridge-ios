//
//  StompMessageUpdateDTO.swift
//  Bridge
//
//  Created by 정호윤 on 12/7/23.
//

import Foundation

/// 읽음 여부 업데이트를 위한 타입
struct StompMessageUpdateDTO: Decodable {
    let messageID: String?
    let channelID: String?
    let senderID: Int?
    let type: String?
    let content: String?
    var sentDateAndTime: String?
    var previousMessages: MessageDTO
    
    enum CodingKeys: String, CodingKey {
        case messageID = "messageId"
        case channelID = "chatRoomId"
        case senderID = "senderId"
        case type
        case content = "message"
        case sentDateAndTime = "sendTime"
        case previousMessages = "chatHistory"
    }
}

// MARK: - Custom type
extension StompMessageUpdateDTO {
    enum MessageResponseType: String {
        case talk = "TALK"
        case accept = "ACCEPT"
        case reject = "REJECT"
    }
}

// MARK: - Entity mapping
extension StompMessageUpdateDTO {
    func toEntity(userID: String) -> [Message] {
        previousMessages.toEntity(userID: userID)
    }
}
