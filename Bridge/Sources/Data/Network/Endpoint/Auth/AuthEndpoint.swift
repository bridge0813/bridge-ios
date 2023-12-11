//
//  AuthEndpoint.swift
//  Bridge
//
//  Created by 정호윤 on 2023/09/19.
//

enum AuthEndpoint {
    case signInWithApple(requestDTO: SignInWithAppleRequestDTO)
    case signUp(requestDTO: SignUpRequestDTO)
}

extension AuthEndpoint: Endpoint {
    var path: String {
        switch self {
        case .signInWithApple:
            return "/login/apple"
            
        case .signUp:
            return "/signup"
        }
    }
    
    var queryParameters: QueryParameters? {
        switch self {
        case .signInWithApple:
            return nil
            
        case .signUp:
            return nil
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .signInWithApple:
            return .post
            
        case .signUp:
            return .post
        }
    }
    
    var body: Encodable? {
        switch self {
        case .signInWithApple(let requestDTO):
            return requestDTO
            
        case .signUp(let requestDTO):
            return requestDTO
        }
    }
}
