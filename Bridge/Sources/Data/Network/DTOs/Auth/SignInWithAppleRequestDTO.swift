//
//  SignInWithAppleRequestDTO.swift
//  Bridge
//
//  Created by 정호윤 on 2023/09/22.
//

struct SignInWithAppleRequestDTO: Encodable {
    let name: String     // user name
    let idToken: String  // identity token
}
