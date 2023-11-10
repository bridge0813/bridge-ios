//
//  AccessTokenResponseDTO.swift
//  Bridge
//
//  Created by 정호윤 on 11/7/23.
//

/// Refresh token으로 재발급 받은 access token을 위한 DTO
struct AccessTokenResponseDTO: Decodable {
    let accessToken: String
}
