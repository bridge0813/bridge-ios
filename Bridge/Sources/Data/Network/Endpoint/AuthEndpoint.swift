//
//  AuthEndpoint.swift
//  Bridge
//
//  Created by 정호윤 on 2023/09/19.
//

import Foundation

enum AuthEndpoint {
    case signInWithApple(request: SignInWithAppleRequestDTO)
    case signUp(request: SignUpRequestDTO)
}

extension AuthEndpoint: Endpoint {    
    var method: HTTPMethod {
        switch self {
        case .signInWithApple, .signUp:
            return .POST
        }
    }
    
    // TODO: 배포 후 수정
    var baseURL: URL? {
        URL(string: "https://base-url.com")
    }
    
    var path: String {
        switch self {
        case .signInWithApple:  return "/login/apple"
        case .signUp:           return "/signup"
        }
    }
    
    var parameters: HTTPRequestParameter? {
        switch self {
        case .signInWithApple(let request):
            return .body(request)
            
        case .signUp(let request):
            return .body(request)
        }
    }
}
