//
//  SignInWithAppleResponseDTO.swift
//  Bridge
//
//  Created by 정호윤 on 2023/09/23.
//

struct SignInWithAppleResponseDTO: Decodable {
    let grantType: String       // access token type (Bearer)
    let accessToken: String     // 유효시간 30분
    let refreshToken: String
    let userID: Int             // 유저 고유 ID
    let platformID: String      // 유저 고유 Apple ID
    let isRegistered: Bool
    
    enum CodingKeys: String, CodingKey {
        case grantType
        case accessToken
        case refreshToken
        case userID = "userId"
        case platformID = "platformId"
        case isRegistered = "registered"
    }
}
