//
//  Message.swift
//  Bridge
//
//  Created by 정호윤 on 2023/08/28.
//

import Foundation

struct Message {
    
    enum MessageType: String, Codable {
        case text
        case image
        case file
    }
    
    enum Sender {
        case me
        case opponent
    }
    
    enum State {
        case read
        case unread
    }
    
    let content: String
}
