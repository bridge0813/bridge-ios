//
//  SignInResponseDTO.swift
//  Bridge
//
//  Created by 정호윤 on 2023/09/23.
//

struct SignInResponseDTO: Decodable {
    let grantType: String       // access token type
    let accessToken: String     // 유효시간 30분
    let refreshToken: String
    let email: String
    let isRegistered: Bool
    let userId: Int
}
