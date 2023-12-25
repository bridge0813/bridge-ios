//
//  CreateChannelRequestDTO.swift
//  Bridge
//
//  Created by 엄지호 on 12/23/23.
//

import Foundation

struct CreateChannelRequestDTO: Encodable {
    let myID: Int
    let opponentID: Int
    
    enum CodingKeys: String, CodingKey {
        case myID = "makeUserId"
        case opponentID = "receiveUserId"
    }
}
