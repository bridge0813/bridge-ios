//
//  ChannelDTO.swift
//  Bridge
//
//  Created by 정호윤 on 2023/08/29.
//

import Foundation

struct ChannelDTO: Codable {
    let id: String?
    var image: String?
    let name: String
    var lastMessageReceivedTime: String?
//    let lastMessageType: String
    var lastMessageContent: String?
//    let unreadMessageCount: String
    
    enum CodingKeys: String, CodingKey {
        case id = "roomId"
        case image
        case name = "roomName"
        case lastMessageReceivedTime = "lastTime"
//        case lastMessageType // tbd
        case lastMessageContent = "lastMessage"
//        case unreadMessageCount  // tbd
    }
}

// MARK: - For test
extension ChannelDTO {
    // TODO: 수정 필요 (id 충돌 주의)
    func toEntity() -> Channel {
        Channel(
            id: id ?? "-1",  // 얘도 임시로 해논거라 옵셔널 제거해야함
            myID: "",
            opponentID: "",
            image: nil,
            name: name,
            lastMessage: Channel.LastMessage(
                receivedTime: lastMessageReceivedTime?.toTime() ?? "",
                content: lastMessageContent ?? "최신 메시지가 존재하지 않습니다."
            ),
            unreadMessageCount: "0"
        )
    }
}

extension String {
    func toTime() -> String? {
        var isoString = self
        isoString += "+09:00"
        
        // ISO 8601 형식의 문자열을 Date 객체로 변환
        let isoFormatter = ISO8601DateFormatter()
//        isoFormatter.formatOptions = [.withFullDate, .withFullTime]
        guard let date = isoFormatter.date(from: isoString) else { return nil }
        
        // Date 객체를 "오전/오후 x시 x분" 형태로 변환
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "a h시 mm분"
        
        return dateFormatter.string(from: date)
    }
}


extension ChannelDTO {
    static var testArray: [ChannelDTO] = [
//        ChannelDTO(
//            id: "1",
//            image: "urlString",
//            name: "정호윤",
//            lastMessageReceivedTime: "2023-09-05T09:15:30+00:00",
//            lastMessageType: "text",
//            lastMessageContent: "수신된 가장 최근 메시지를 표시합니다.",
//            unreadMessageCount: "0"
//        ),
//        ChannelDTO(
//            id: "2",
//            image: "urlString",
//            name: "채팅방 2",
//            lastMessageReceivedTime: "2023-09-04T15:45:10+00:00",
//            lastMessageType: "text",
//            lastMessageContent: "수신된 가장 최근 메시지를 표시합니다.",
//            unreadMessageCount: "10"
//        ),
//        ChannelDTO(
//            id: "3",
//            image: "urlString",
//            name: "채팅방 이름이 길어진 경우에 대한 테스트입니다.",
//            lastMessageReceivedTime: "2023-09-06T11:00:00+00:00",
//            lastMessageType: "image",
//            lastMessageContent: "이미지가 수신된 경우의 미리보기 메시지입니다.",
//            unreadMessageCount: "1000"
//        ),
//        ChannelDTO(
//            id: "4",
//            image: "urlString",
//            name: "채팅방 4",
//            lastMessageReceivedTime: "2023-09-04T19:30:20+00:00",
//            lastMessageType: "text",
//            lastMessageContent: "수신된 가장 최근 메시지를 표시합니다.",
//            unreadMessageCount: "999"
//        ),
//        ChannelDTO(
//            id: "5",
//            image: "urlString",
//            name: "채팅방 5",
//            lastMessageReceivedTime: "2023-09-04T04:55:55+00:00",
//            lastMessageType: "text",
//            lastMessageContent: "수신된 가장 최근 메시지를 표시합니다.",
//            unreadMessageCount: "1"
//        ),
//        ChannelDTO(
//            id: "6",
//            image: "urlString",
//            name: "채팅방 6",
//            lastMessageReceivedTime: "2023-09-02T12:34:56+00:00",
//            lastMessageType: "text",
//            lastMessageContent: "수신된 가장 최근 메시지를 표시합니다.",
//            unreadMessageCount: "7"
//        )
    ]
}
