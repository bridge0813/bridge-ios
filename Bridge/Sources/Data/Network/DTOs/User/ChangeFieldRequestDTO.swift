//
//  ChangeFieldRequestDTO.swift
//  Bridge
//
//  Created by 정호윤 on 12/22/23.
//

import Foundation

struct ChangeFieldRequestDTO: Encodable {
    let userID: Int
    let selectedFields: [String]
    
    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case selectedFields = "fields"
    }
}
