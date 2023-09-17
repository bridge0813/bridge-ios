//
//  UserCredentials.swift
//  Bridge
//
//  Created by 정호윤 on 2023/09/13.
//

import Foundation

struct UserCredentials {
    let id: String
    let name: String
    let identityToken: Data?
    let authorizationCode: Data?
}

extension UserCredentials {
    static let onError = UserCredentials(
        id: "",
        name: "",
        identityToken: nil,
        authorizationCode: nil
    )
}
