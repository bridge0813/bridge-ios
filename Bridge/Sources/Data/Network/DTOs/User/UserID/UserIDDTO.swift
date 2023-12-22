//
//  UserIDDTO.swift
//  Bridge
//
//  Created by 엄지호 on 12/17/23.
//

// 서버와 userID를 주고 받을 때 사용되는 DTO
struct UserIDDTO: Codable {
    let userID: Int
    
    enum CodingKeys: String, CodingKey {
        case userID = "userId"
    }
}
