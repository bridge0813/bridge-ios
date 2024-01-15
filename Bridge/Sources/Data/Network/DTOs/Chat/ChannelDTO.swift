//
//  ChannelDTO.swift
//  Bridge
//
//  Created by 정호윤 on 2023/08/29.
//

import Foundation

struct ChannelDTO: Codable {
    let channelID: String
    let myID: Int
    let opponentID: Int
    let imageURL: String?
    let name: String
    let lastMessageReceivedTime: String?
    let lastMessageContent: String?
    let unreadMessageCount: Int
    
    enum CodingKeys: String, CodingKey {
        case channelID = "roomId"
        case myID = "makerId"
        case opponentID = "receiverId"
        case imageURL = "image"
        case name = "roomName"
        case lastMessageReceivedTime = "lastTime"
        case lastMessageContent = "lastMessage"
        case unreadMessageCount = "notReadMessageCnt"
    }
}

extension ChannelDTO {
    func toEntity() -> Channel {
        Channel(
            id: channelID,
            myID: String(myID),
            opponentID: String(opponentID),
            imageURL: imageURL,
            name: name,
            lastMessage: Channel.LastMessage(
                receivedTime: lastMessageReceivedTime?.toDetailedTime() ?? "",
                content: lastMessageContent ?? "최신 메시지가 존재하지 않습니다."
            ),
            unreadMessageCount: unreadMessageCount
        )
    }
}

extension ChannelDTO {
    static var testArray: [ChannelDTO] = [
        ChannelDTO(
            channelID: "1",
            myID: 1,
            opponentID: 2,
            imageURL: "https://firebasestorage.googleapis.com/v0/b/cookingproject-5bf82.appspot.com/o/saveImage1677219882.2262769?alt=media&token=12b9aab3-a0b0-498f-bc81-0e8a8858d481",
            name: "정호윤",
            lastMessageReceivedTime: "2023-09-05T09:15:30+00:00",
            lastMessageContent: "수신된 가장 최근 메시지를 표시합니다.",
            unreadMessageCount: 0
        ),
        ChannelDTO(
            channelID: "2",
            myID: 1,
            opponentID: 2,
            imageURL: nil,
            name: "채팅방 2",
            lastMessageReceivedTime: "2023-09-04T15:45:10+00:00",
            lastMessageContent: "수신된 가장 최근 메시지를 표시합니다.",
            unreadMessageCount: 2
        ),
        ChannelDTO(
            channelID: "3",
            myID: 1,
            opponentID: 2,
            imageURL: nil,
            name: "채팅방 이름이 길어진 경우에 대한 테스트입니다.",
            lastMessageReceivedTime: "2023-09-06T11:00:00+00:00",
            lastMessageContent: "이미지가 수신된 경우의 미리보기 메시지입니다.",
            unreadMessageCount: 10
        ),
        ChannelDTO(
            channelID: "4",
            myID: 1,
            opponentID: 2,
            imageURL: nil,
            name: "채팅방 4",
            lastMessageReceivedTime: "2023-09-04T19:30:20+00:00",
            lastMessageContent: "수신된 가장 최근 메시지를 표시합니다.",
            unreadMessageCount: 1000
        ),
        ChannelDTO(
            channelID: "5",
            myID: 1,
            opponentID: 2,
            imageURL: nil,
            name: "채팅방 5",
            lastMessageReceivedTime: "2023-09-04T04:55:55+00:00",
            lastMessageContent: "수신된 가장 최근 메시지를 표시합니다.",
            unreadMessageCount: 0
        ),
        ChannelDTO(
            channelID: "6",
            myID: 1,
            opponentID: 2,
            imageURL: nil,
            name: "채팅방 6",
            lastMessageReceivedTime: "2023-09-02T12:34:56+00:00",
            lastMessageContent: "수신된 가장 최근 메시지를 표시합니다.",
            unreadMessageCount: 100
        )
    ]
}
