//
//  MessageDTO.swift
//  Bridge
//
//  Created by 정호윤 on 11/13/23.
//

import Foundation

struct MessageDTO: Decodable {
    let content: String
    let sender: String
    let sentDate: String
    let sentTime: String
    
    enum CodingKeys: String, CodingKey {
        case content
        case sender = "senderType"
        case sentDate = "sendDate"
        case sentTime = "sendTime"
    }
}

extension MessageDTO {
    func toEntity() -> Message {
        Message(
            id: UUID().uuidString,
            sender: sender == "MAKER" ? .me : .opponent,
            type: .text(content),
            sentDate: "23-11-13",
            sentTime: "오후 12:00",
            state: .unread
        )
    }
}
