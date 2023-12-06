//
//  MessageDTO.swift
//  Bridge
//
//  Created by 정호윤 on 11/13/23.
//

import Foundation

/// 채널의 기존 메시지들을 불러오기 위한 타입
struct MessageDTO: Decodable {
    let chatHistory: [ChatHistory]
}

struct ChatHistory: Decodable {
    let messageID: String
    let senderID: Int
    let type: String
    let content: String
    let sentDateAndTime: String
    let hasRead: Bool
    
    enum CodingKeys: String, CodingKey {
        case messageID = "messageId"
        case senderID = "senderId"
        case type
        case content
        case sentDateAndTime = "sendTime"
        case hasRead = "readStat"
    }
}

// MARK: - Custom type
extension ChatHistory {
    enum MessageResponseType: String {
        case talk = "TALK"
        case accept = "ACCEPT"
        case reject = "REJECT"
    }
}

// MARK: - Entity mapping
extension ChatHistory {
    func toEntity(userID: String) -> Message {
        Message(
            id: messageID,
            sender: Int(userID) == senderID ? .me : .opponent,
            type: mapToMessageType(type),
            sentDate: sentDateAndTime.toDate() ?? "",
            sentTime: sentDateAndTime.toSimpleTime() ?? "",
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

extension MessageDTO {
    static var testArray: [ChatHistory] = [
//        MessageDTO(
//            messageID: UUID().uuidString,
//            senderID: 1,
//            type: "TALK",
//            content: "안녕하세요",
//            sentDateAndTime: "2023-11-13T18:18:00",
//            hasRead: false
//        ),
//        MessageDTO(
//            messageID: UUID().uuidString,
//            senderID: 1,
//            type: "TALK",
//            content: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",
//            sentDateAndTime: "2023-11-14T18:20:00",
//            hasRead: false
//        ),
//        MessageDTO(
//            messageID: UUID().uuidString,
//            senderID: 1,
//            type: "TALK",
//            content: "안녕하세요 반갑습니다!",
//            sentDateAndTime: "2023-11-15T18:20:00",
//            hasRead: true
//        ),
//        MessageDTO(
//            messageID: UUID().uuidString,
//            senderID: 1,
//            type: "REJECT",
//            content: "안녕하세요 반갑습니다!",
//            sentDateAndTime: "2023-11-15T18:20:00",
//            hasRead: true
//        ),
//        MessageDTO(
//            messageID: UUID().uuidString,
//            senderID: 1,
//            type: "ACCEPT",
//            content: "안녕하세요 반갑습니다!",
//            sentDateAndTime: "2023-11-15T18:20:00",
//            hasRead: true
//        )
    ]
}
