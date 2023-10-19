//
//  ChatRoom.swift
//  Bridge
//
//  Created by 정호윤 on 2023/08/28.
//

import Foundation

struct ChatRoom {
    /// 가장 최근에 수신된 메시지와 관련된 정보를 저장하기 위한 타입
    struct LastMessage {
        let receivedTime: String
        let type: Message.MessageType
        let content: String
    }
    
    let id: String
    let profileImageURL: URL?

    /// 채팅방 이름 (수신자 이름)
    let name: String
    
    /// 가장 최근에 수신된 메시지에 대한 정보
    let lastMessage: LastMessage

    /// 읽지 않은 메시지 개수
    let unreadMessageCount: String
}

extension ChatRoom {
    static let onError = ChatRoom(
        id: UUID().uuidString,
        profileImageURL: nil,
        name: "채팅방 이름을 불러올 수 없습니다.",
        lastMessage: LastMessage(
            receivedTime: String(),
            type: .text,
            content: "메시지를 불러올 수 없습니다."
        ),
        unreadMessageCount: "0"
    )
}

extension ChatRoom: Hashable { }
extension ChatRoom.LastMessage: Hashable { }
