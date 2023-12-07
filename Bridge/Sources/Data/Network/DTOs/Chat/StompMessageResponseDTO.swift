//
//  StompMessageResponseDTO.swift
//  Bridge
//
//  Created by 정호윤 on 11/15/23.
//

import Foundation

/// STOMP 메시지 응답을 위한 타입
struct StompMessageResponseDTO: Decodable {
    let messageID: String
    let channelID: String
    let senderID: Int
    let type: String
    let content: String
    let hasRead: Bool
    var sentDateAndTime: String?
    var previousMessages: [PreviousMessageDTO]?
    
    enum CodingKeys: String, CodingKey {
        case messageID = "messageId"
        case channelID = "chatRoomId"
        case senderID = "senderId"
        case type
        case content = "message"
        case hasRead = "readStat"
        case sentDateAndTime = "sendTime"
        case previousMessages = "chatHistory"
    }
}

// MARK: - Custom type
extension StompMessageResponseDTO {
    enum MessageResponseType: String {
        case talk = "TALK"
        case accept = "ACCEPT"
        case reject = "REJECT"
    }
}

// MARK: - Entity mapping
extension StompMessageResponseDTO {
    func toEntity(userID: String) -> Message {
        Message(
            id: messageID,
            sender: Int(userID) == senderID ? .me : .opponent,
            type: mapToMessageType(type),
            sentDate: sentDateAndTime?.toDate(),
            sentTime: sentDateAndTime?.toSimpleTime(),
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
