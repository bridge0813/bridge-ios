//
//  SignInResponseDTO.swift
//  Bridge
//
//  Created by 정호윤 on 2023/09/23.
//

struct SignInResponseDTO: Decodable {
    let grantType: String       // access token type (Bearer)
    let accessToken: String     // 유효시간 30분
    let refreshToken: String
    var email: String?
    let platformID: String      // 유저 고유 ID
    let isRegistered: Bool
    
    enum CodingKeys: String, CodingKey {
        case grantType
        case accessToken
        case refreshToken
        case email
        case platformID = "platformId"
        case isRegistered = "registered"
    }
}
