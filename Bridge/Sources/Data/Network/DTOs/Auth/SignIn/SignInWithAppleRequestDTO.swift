//
//  SignInWithAppleRequestDTO.swift
//  Bridge
//
//  Created by 정호윤 on 2023/09/22.
//

struct SignInWithAppleRequestDTO: Encodable {
    let userName: String
    let identityToken: String
    
    enum CodingKeys: String, CodingKey {
        case userName = "name"
        case identityToken = "idToken"
    }
}
