//
//  ChatRoomDTO.swift
//  Bridge
//
//  Created by 정호윤 on 2023/08/29.
//

import Foundation

struct ChatRoomDTO: Codable {
    let id: String
    let profileImage: String
    let name: String
    let latestMessageReceivedTime: String
    let latestMessageType: String
    let latestMessageContent: String
    let unreadMessageCount: String
}

// MARK: - For test
extension ChatRoomDTO {
    func toDomain() -> ChatRoom {
        ChatRoom(
            id: id,
            profileImageURL: URL(string: profileImage),
            name: name,
            latestMessage: ChatRoom.LatestMessage(
                receivedTime: latestMessageReceivedTime.toTimeString() ?? "오류",
                type: .text,
                content: latestMessageContent
            ),
            unreadMessageCount: unreadMessageCount
        )
    }
}

extension String {
    func toTimeString() -> String? {
        // ISO 8601 문자열을 Date 객체로 변환
        let isoFormatter = ISO8601DateFormatter()
        guard let date = isoFormatter.date(from: self) else { return nil }
        
        // Date 객체를 "오전/오후 x시 x분" 형태로 변환
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "a h시 mm분"
        
        return formatter.string(from: date)
    }
}


extension ChatRoomDTO {
    static var testArray = [
        ChatRoomDTO(
            id: "1",
            profileImage: "urlString",
            name: "정호윤",
            latestMessageReceivedTime: "2023-09-04T09:15:30+00:00",
            latestMessageType: "text",
            latestMessageContent: "수신된 가장 최근 메시지를 표시합니다.",
            unreadMessageCount: "0"
        ),
        ChatRoomDTO(
            id: "2",
            profileImage: "urlString",
            name: "채팅방 2",
            latestMessageReceivedTime: "2023-09-04T15:45:10+00:00",
            latestMessageType: "text",
            latestMessageContent: "수신된 가장 최근 메시지를 표시합니다.",
            unreadMessageCount: "10"
        ),
        ChatRoomDTO(
            id: "3",
            profileImage: "urlString",
            name: "채팅방 이름이 길어진 경우에 대한 테스트입니다.",
            latestMessageReceivedTime: "2023-09-04T11:00:00+00:00",
            latestMessageType: "image",
            latestMessageContent: "이미지가 수신된 경우의 미리보기 메시지입니다.",
            unreadMessageCount: "1000"
        ),
        ChatRoomDTO(
            id: "4",
            profileImage: "urlString",
            name: "채팅방 4",
            latestMessageReceivedTime: "2023-09-04T19:30:20+00:00",
            latestMessageType: "text",
            latestMessageContent: "수신된 가장 최근 메시지를 표시합니다.",
            unreadMessageCount: "999"
        ),
        ChatRoomDTO(
            id: "5",
            profileImage: "urlString",
            name: "채팅방 5",
            latestMessageReceivedTime: "2023-09-04T04:55:55+00:00",
            latestMessageType: "text",
            latestMessageContent: "수신된 가장 최근 메시지를 표시합니다.",
            unreadMessageCount: "1"
        ),
        ChatRoomDTO(
            id: "6",
            profileImage: "urlString",
            name: "채팅방 6",
            latestMessageReceivedTime: "2023-09-04T12:34:56+00:00",
            latestMessageType: "text",
            latestMessageContent: "수신된 가장 최근 메시지를 표시합니다.",
            unreadMessageCount: "7"
        )
    ]
}
