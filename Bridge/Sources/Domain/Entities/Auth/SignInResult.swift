//
//  SignInResult.swift
//  Bridge
//
//  Created by 정호윤 on 2023/09/13.
//

enum SignInResult {
    /// 회원가입이 필요한 신규 유저
    case signUpNeeded
    
    /// 로그인 성공
    case success
    
    /// 실패
    case failure
}
