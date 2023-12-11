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
    let sentDate: String?
    let sentTime: String?
    let hasRead: Bool
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
    case reject
}

extension Message {
    static let onError = Message(
        id: UUID().uuidString,
        sender: .me,
        type: .text("메시지 불러올 수 없습니다"),
        sentDate: "날짜를 불러올 수 없습니다.",
        sentTime: "시간을 불러올 수 없습니다.",
        hasRead: false
    )
}

extension MessageType {
    var content: String? {
        switch self {
        case .text(let content):    
            return content
            
        default:                    
            return nil
        }
    }
}

extension Message: Hashable { }
extension Sender: Hashable { }
extension MessageType: Hashable { }
