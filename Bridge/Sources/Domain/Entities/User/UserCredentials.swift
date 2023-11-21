//
//  UserCredentials.swift
//  Bridge
//
//  Created by 정호윤 on 2023/09/13.
//

import Foundation

struct UserCredentials {
    let id: String
    let userName: String?
    let givenName: String?
    let identityToken: String?
    let authorizationCode: String?
}

extension UserCredentials {
    static let onError = UserCredentials(
        id: "",
        userName: nil,
        givenName: nil,
        identityToken: nil,
        authorizationCode: nil
    )
}
