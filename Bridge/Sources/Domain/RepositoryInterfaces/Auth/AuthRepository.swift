//
//  AuthRepository.swift
//  Bridge
//
//  Created by 정호윤 on 2023/09/13.
//

import RxSwift

protocol AuthRepository {
    /// 애플 로그인
    func signInWithApple(credentials: UserCredentials) -> Observable<Bool>
    
    /// 회원가입
    func signUp(selectedFields: [String]) -> Observable<Void>
    
    /// 로그아웃
    func signOut() -> Observable<Void>
    
    /// 회원 탈퇴
    func withdraw() -> Observable<Void>
}
