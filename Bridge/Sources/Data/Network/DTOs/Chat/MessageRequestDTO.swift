//
//  MessageRequestDTO.swift
//  Bridge
//
//  Created by 정호윤 on 11/15/23.
//

import Foundation

struct MessageRequestDTO: Codable {
    let channelID: String
    let type: String
    let sender: String
    let content: String
    
    enum CodingKeys: String, CodingKey {
        case channelID = "chatRoomId"
        case type
        case sender
        case content = "message"
    }
    
    init(channelID: String, type: MessageType, sender: String, content: String) {
        self.channelID = channelID
        self.type = type.rawValue
        self.sender = sender
        self.content = content
    }
}

extension MessageRequestDTO {
    enum MessageType: String {
        case talk = "TALK"
        case accept
        case refuse
    }
}

// TODO: 수정필요!
extension MessageRequestDTO {
    func toEntity() -> Message {
        Message(
            id: UUID().uuidString,
            sender: .me,
            type: .text(content),
            sentDate: "",
            sentTime: "",
            state: .read
        )
    }
}
