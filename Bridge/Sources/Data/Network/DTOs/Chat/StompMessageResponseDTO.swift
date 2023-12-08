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
    var sentDateAndTime: String?
    let hasRead: Bool
    var previousMessages: [MessageDTO]?
    
    enum CodingKeys: String, CodingKey {
        case messageID = "messageId"
        case channelID = "chatRoomId"
        case senderID = "senderId"
        case type
        case content = "message"
        case sentDateAndTime = "sendTime"
        case hasRead = "readStat"
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

extension StompMessageResponseDTO {
    static let testData = StompMessageResponseDTO(
        messageID: UUID().uuidString,
        channelID: "1",
        senderID: 2,
        type: "TALK",
        content: "stomp response test",
        sentDateAndTime: "2023-11-16T11:30:00",
        hasRead: false
    )
}
