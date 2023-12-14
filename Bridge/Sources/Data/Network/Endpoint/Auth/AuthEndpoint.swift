//
//  AuthEndpoint.swift
//  Bridge
//
//  Created by 정호윤 on 2023/09/19.
//

enum AuthEndpoint {
    case signInWithApple(requestDTO: SignInWithAppleRequestDTO)
    case signUp(requestDTO: SignUpRequestDTO)
    case signOut(userID: String)
    case withdrawal(userID: String)
}

extension AuthEndpoint: Endpoint {
    var path: String {
        switch self {
        case .signInWithApple:
            return "/login/apple"
            
        case .signUp:
            return "/signup"
            
        case .signOut:
            return "/logout"
            
        case .withdrawal(let userID):
            return "/users/\(userID)"
        }
    }
    
    var queryParameters: QueryParameters? {
        switch self {
        case .signInWithApple:
            return nil
            
        case .signUp:
            return nil
            
        case .signOut(let userID):
            return ["userId": userID]
            
        case .withdrawal(userID: let userID):
            return ["userId": userID]
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .signInWithApple:
            return .post
            
        case .signUp:
            return .post
            
        case .signOut:
            return .post
            
        case .withdrawal:
            return .delete
        }
    }
    
    var body: Encodable? {
        switch self {
        case .signInWithApple(let requestDTO):
            return requestDTO
            
        case .signUp(let requestDTO):
            return requestDTO
            
        case .signOut:
            return nil
            
        case .withdrawal:
            return nil
        }
    }
}
