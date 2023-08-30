//
//  ChatRoomDTO.swift
//  Bridge
//
//  Created by 정호윤 on 2023/08/29.
//

import Foundation

struct ChatRoomDTO: Codable {
    let id: String
    let profileImage: URL?
    let name: String
    let time: Date
    let messageType: Chat.MessageType
    let messagePreview: String
}

extension ChatRoomDTO {
    func toModel() -> ChatRoom {
        ChatRoom(
            id: id,
            profileImage: profileImage,
            name: name,
            time: time,
            messageType: messageType,
            messagePreview: messagePreview
        )
    }
}
