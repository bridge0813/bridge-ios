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
    let myProfileImageURL: String  // 사용안함(서버 측 JSON 구조 맞추기)
    let opponentID: Int
    let opponentProfileImageURL: String
    
    enum CodingKeys: String, CodingKey {
        case channelID = "chatRoomId"
        case myID = "makeUserId"
        case myProfileImageURL = "makeUserPhotoUrl"
        case opponentID = "receiveUserId"
        case opponentProfileImageURL = "receiveUserPhotoUrl"
    }
}

extension CreateChannelResponseDTO {
    func toEntity() -> Channel {
        Channel(
            id: channelID,
            myID: String(myID),
            opponentID: String(opponentID),
            imageURL: opponentProfileImageURL,
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
    static var testData = CreateChannelResponseDTO(channelID: "", myID: 2, myProfileImageURL: "", opponentID: 1, opponentProfileImageURL: "https://firebasestorage.googleapis.com/v0/b/cookingproject-5bf82.appspot.com/o/saveImage1677219882.2262769?alt=media&token=12b9aab3-a0b0-498f-bc81-0e8a8858d481")
}
