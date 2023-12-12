//
//  MockAuthRepository.swift
//  Bridge
//
//  Created by 정호윤 on 10/8/23.
//

import RxSwift

final class MockAuthRepository: AuthRepository {
    func signInWithApple(credentials: UserCredentials) -> Observable<Bool> {
        .just(false)
    }
    
    func signUp(selectedFields: [String]) -> Observable<Void> {
        .just(())
    }
}
