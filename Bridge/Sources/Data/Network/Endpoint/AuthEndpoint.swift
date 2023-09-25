//
//  AuthEndpoint.swift
//  Bridge
//
//  Created by 정호윤 on 2023/09/19.
//

import Foundation

enum AuthEndpoint {
    case signInWithApple(request: SignInWithAppleRequestDTO)
}

extension AuthEndpoint: Endpoint {    
    var method: HTTPMethod {
        switch self {
        case .signInWithApple:
            return .POST
        }
    }
    
    var baseURL: URL? {
        URL(string: "https://base-url.com")  // 백엔드 배포 후 수정
    }
    
    var path: String {
        switch self {
        case .signInWithApple:
            return "/login/apple"
        }
    }
    
    var parameters: HTTPRequestParameter? {
        switch self {
        case .signInWithApple(let request):
            return .body(request)
        }
    }
}
