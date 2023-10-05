//
//  SignInUseCase.swift
//  Bridge
//
//  Created by 정호윤 on 2023/09/13.
//

import RxSwift

protocol SignInUseCase {
    func signInWithApple(credentials: UserCredentials) -> Single<SignInResult>
}

final class DefaultSignInUseCase: SignInUseCase {
    
    private let authRepository: AuthRepository
    
    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
    
    func signInWithApple(credentials: UserCredentials) -> Single<SignInResult> {
        authRepository.signInWithApple(credentials: credentials)
    }
}
