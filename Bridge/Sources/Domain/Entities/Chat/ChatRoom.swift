//
//  ChatRoom.swift
//  Bridge
//
//  Created by 정호윤 on 2023/08/28.
//

import Foundation

struct ChatRoom {
    let id: String
    let profileImage: URL?
    let name: String
    let time: Date
    let messageType: Chat.MessageType
    let messagePreview: String
}

extension ChatRoom {
    static var onError: Self {
        ChatRoom(
            id: UUID().uuidString,
            profileImage: nil,
            name: "오류",
            time: Date(),
            messageType: .text,
            messagePreview: "오류가 발생했습니다."
        )
    }
}

extension ChatRoom: Hashable { }
