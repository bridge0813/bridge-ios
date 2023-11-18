//
//  MessageDTO.swift
//  Bridge
//
//  Created by 정호윤 on 11/13/23.
//

import Foundation

/// 채널의 기존 메시지들을 불러오는데 사용하기 위한 타입
struct MessageDTO: Decodable {
    let content: String
    let sender: String
    let sentDateAndTime: String
    let hasRead: Bool
    
    enum CodingKeys: String, CodingKey {
        case content
        case sender = "senderType"
        case sentDateAndTime = "sendTime"
        case hasRead = "readStat"
    }
    
    init(content: String, sender: SenderType, sentDateAndTime: String, hasRead: Bool) {
        self.content = content
        self.sender = sender.rawValue
        self.sentDateAndTime = sentDateAndTime
        self.hasRead = hasRead
    }
}

// MARK: - Custom type
extension MessageDTO {
    enum SenderType: String {
        case me = "MAKER"
        case opponent = "APPLIER"
    }
}

// MARK: - Entity mapping
extension MessageDTO {
    func toEntity() -> Message {
        Message(
            id: UUID().uuidString,
            sender: sender == "MAKER" ? .me : .opponent,
            type: .text(content),
            sentDate: sentDateAndTime.toDate() ?? "",
            sentTime: sentDateAndTime.toSimpleTime() ?? "",
            hasRead: hasRead
        )
    }
}

extension MessageDTO {
    static var testArray = [
        MessageDTO(
            content: "안녕하세요",
            sender: .me,
            sentDateAndTime: "2023-11-13T18:18:00",
            hasRead: false
        ),
        MessageDTO(
            content: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",
            sender: .opponent,
            sentDateAndTime: "2023-11-14T18:20:00",
            hasRead: false
        ),
        // 백엔드 바뀌면 accept, reject 메시지 추가
//        Message(
//            id: "9",
//            sender: .me,
//            type: .accept,
//            sentDate: "2023년 10월 26일 목요일",
//            sentTime: "오후 1:00",
//            state: .unread
//        ),
//        Message(
//            id: "10",
//            sender: .opponent,
//            type: .reject,
//            sentDate: "2023년 10월 26일 목요일",
//            sentTime: "오후 1:00",
//            state: .unread
//        ),
        MessageDTO(
            content: "안녕하세요 반갑습니다!",
            sender: .me,
            sentDateAndTime: "2023-11-15T18:20:00",
            hasRead: true
        )
    ]
}
