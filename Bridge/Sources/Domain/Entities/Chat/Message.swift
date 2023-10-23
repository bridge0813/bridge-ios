//
//  Message.swift
//  Bridge
//
//  Created by 정호윤 on 2023/08/28.
//

import Foundation

struct Message {
    let id: String
    let sender: Sender
    let type: MessageType
    let sentTime: String
    let state: State
}

enum Sender {
    case me
    case opponent
}

enum MessageType {
    case text(String)
    case image
    case file
    case accept
    case refuse
}

enum State {
    case read
    case unread
}

extension Message: Hashable { }
extension Sender: Hashable { }
extension MessageType: Hashable { }

extension Message {
    static let onError = Message(
        id: UUID().uuidString,
        sender: .me,
        type: .text("오류가 발생했습니다."),
        sentTime: Date().toString(),
        state: .read
    )
}
