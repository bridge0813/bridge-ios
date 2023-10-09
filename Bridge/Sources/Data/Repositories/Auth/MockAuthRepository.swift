//
//  MockAuthRepository.swift
//  Bridge
//
//  Created by 정호윤 on 10/8/23.
//

import RxSwift

final class MockAuthRepository: AuthRepository {
    // MARK: - Sign in
    func signInWithApple(credentials: UserCredentials) -> Single<SignInResult> {
        Single.just(.needSignUp)
    }
    
    // MARK: - Sign up
    func signUp(selectedFields: [String]) -> Single<Void> {
        Single.error(NetworkError.unknown)
//        Single.just(())
    }
}
