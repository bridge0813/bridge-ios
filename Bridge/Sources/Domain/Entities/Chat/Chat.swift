//
//  Chat.swift
//  Bridge
//
//  Created by 정호윤 on 2023/08/28.
//

import Foundation

struct Chat {
    
    enum MessageType: String, Codable {
        case text
        case image
        case file
    }
    
    enum Sender {
        case me
        case opponent
    }
    
    // TODO: API, 디자인 확인하고 수정
    let content: String
}
