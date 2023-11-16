//
//  MessageRequestDTO.swift
//  Bridge
//
//  Created by 정호윤 on 11/15/23.
//

struct MessageRequestDTO: Encodable {
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
