//
//  CreateChannelResponseDTO.swift
//  Bridge
//
//  Created by 엄지호 on 12/13/23.
//

import Foundation

struct CreateChannelResponseDTO: Decodable {
    let channelID: String
    let myID: Int
    let opponentID: Int
    
    enum CodingKeys: String, CodingKey {
        case channelID = "chatRoomId"
        case myID = "makeUserId"
        case opponentID = "receiveUserId"
    }
}

extension CreateChannelResponseDTO {
    func toEntity() -> Channel {
        Channel(
            id: channelID,
            myID: String(myID),
            opponentID: String(opponentID),
            imageURL: nil,
            name: "",
            lastMessage: Channel.LastMessage(
                receivedTime: "",
                content: ""
            ),
            unreadMessageCount: 0
        )
    }
}

extension CreateChannelResponseDTO {
    static var testData = CreateChannelResponseDTO(channelID: "", myID: 2, opponentID: 1)
}
