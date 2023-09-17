//
//  DefaultAuthRepository.swift
//  Bridge
//
//  Created by 정호윤 on 2023/09/13.
//

import RxSwift

// TODO: 토큰 매니저? 추가해서 토큰과 user credential 네트워크 서비스로 넘기기
final class DefaultAuthRepository: AuthRepository {
    
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func signInWithApple(credentials: UserCredentials) -> Observable<SignInResult> {
        networkService.signInWithAppleCredentials(credentials)
    }
    
    func checkUserAuthState() -> Observable<UserAuthState> {
        networkService.checkUserAuthState()
    }
}
